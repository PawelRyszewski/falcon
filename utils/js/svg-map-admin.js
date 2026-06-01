(function () {
    'use strict';

    var STATE = {
        categoryId: 0,
        saveUrl: '',
        properties: [],
        imageId: 0,
        imageName: '',
        imageWidth: 0,
        imageHeight: 0,
        shapes: [],
        drawing: false,
        currentPoints: [],
        pendingShapeIdx: null,
        editingShapeIdx: null,
        // move state
        movingShapeIdx: null,
        _isDragging: false,
        _moveStartX: 0,
        _moveStartY: 0,
        _moveOriginalPoints: []
    };

    var STATUS_COLORS = {
        'wolne':       '#2e7d32',
        'rezerwacja':  '#e65100',
        'niedostepne': '#c62828'
    };

    // ── Init ──────────────────────────────────────────────────────────────
    window.svgMapAdminInit = function (categoryId, saveUrl, propertiesJson, existingData) {
        STATE.categoryId = categoryId;
        STATE.saveUrl    = saveUrl;
        STATE.properties = propertiesJson || [];

        if (existingData && existingData.image_id) {
            STATE.imageId     = existingData.image_id;
            STATE.imageName   = existingData.image_name || '';
            STATE.imageWidth  = existingData.image_width || 0;
            STATE.imageHeight = existingData.image_height || 0;
            var raw = existingData.shapes;
            STATE.shapes = (raw && typeof raw === 'string') ? JSON.parse(raw) : (raw || []);
        }

        bindModalEvents();
    };

    function bindModalEvents() {
        var modal = document.getElementById('svgMapBuilderModal');
        if (!modal) return;

        $(modal).on('shown.bs.modal', function () {
            if (STATE.imageId) {
                loadBitmapIntoEditor(STATE.imageName, STATE.imageWidth, STATE.imageHeight);
            } else {
                showPhase('empty');
            }
        });

        $(modal).on('hidden.bs.modal', function () {
            resetDrawingState();
        });

        document.getElementById('btn-svgmap-select-img').addEventListener('click', function () {
            $('#svgmapBitmapPickerModal').modal('show');
        });
        document.getElementById('btn-svgmap-change-img').addEventListener('click', function () {
            $('#svgmapBitmapPickerModal').modal('show');
        });
        document.getElementById('btn-svgmap-draw').addEventListener('click', function () {
            if (STATE.movingShapeIdx !== null) return;
            startDrawing();
        });
        document.getElementById('btn-svgmap-save').addEventListener('click', saveMap);
    }

    // ── Phase management ─────────────────────────────────────────────────
    function showPhase(phase) {
        document.getElementById('svgmap-phase-empty').style.display  = (phase === 'empty')  ? 'block' : 'none';
        document.getElementById('svgmap-phase-editor').style.display = (phase === 'editor') ? 'block' : 'none';
    }

    // ── Bitmap selection ─────────────────────────────────────────────────
    window.svgMapSelectBitmap = function (imgId, imgName) {
        $('#svgmapBitmapPickerModal').modal('hide');
        var img = new Image();
        img.onload = function () {
            STATE.imageId     = imgId;
            STATE.imageName   = imgName;
            STATE.imageWidth  = img.naturalWidth;
            STATE.imageHeight = img.naturalHeight;
            loadBitmapIntoEditor(imgName, img.naturalWidth, img.naturalHeight);
        };
        img.src = '/uploads/' + imgName;
    };

    function loadBitmapIntoEditor(imgName, natW, natH) {
        var bitmapImg = document.getElementById('svgmap-bitmap-img');
        var svg       = document.getElementById('svgmap-svg');

        bitmapImg.src = '/uploads/' + imgName;
        bitmapImg.style.display = 'block';

        if (natW && natH) {
            svg.setAttribute('viewBox', '0 0 ' + natW + ' ' + natH);
            STATE.imageWidth  = natW;
            STATE.imageHeight = natH;
        }

        bitmapImg.onload = function () {
            if (!natW || !natH) {
                STATE.imageWidth  = bitmapImg.naturalWidth;
                STATE.imageHeight = bitmapImg.naturalHeight;
                svg.setAttribute('viewBox', '0 0 ' + STATE.imageWidth + ' ' + STATE.imageHeight);
            }
            refreshShapes();
        };

        showPhase('editor');
        updateSaveButton();
        bindCanvasEvents();
    }

    // ── SVG coordinate helper ─────────────────────────────────────────────
    function getSvgCoords(event) {
        var svg = document.getElementById('svgmap-svg');
        var pt  = svg.createSVGPoint();
        pt.x = event.clientX;
        pt.y = event.clientY;
        return pt.matrixTransform(svg.getScreenCTM().inverse());
    }

    // ── Canvas events ─────────────────────────────────────────────────────
    function bindCanvasEvents() {
        var svg = document.getElementById('svgmap-svg');
        if (svg._svgMapBound) return;
        svg._svgMapBound = true;

        // Click: add drawing point
        svg.addEventListener('click', function (e) {
            if (!STATE.drawing) return;
            e.preventDefault();
            var p = getSvgCoords(e);
            STATE.currentPoints.push({ x: p.x, y: p.y });
            renderCurrentPath();
        });

        // Right-click: finish shape
        svg.addEventListener('contextmenu', function (e) {
            e.preventDefault();
            if (STATE.drawing) finishCurrentShape();
        });

        // Mousedown: start drag-move
        svg.addEventListener('mousedown', function (e) {
            if (STATE.movingShapeIdx === null || e.button !== 0) return;
            e.preventDefault();
            var p = getSvgCoords(e);
            STATE._isDragging      = true;
            STATE._moveStartX      = p.x;
            STATE._moveStartY      = p.y;
            STATE._moveOriginalPoints = STATE.shapes[STATE.movingShapeIdx].points.map(function (pt) {
                return { x: pt.x, y: pt.y };
            });
        });

        // Mousemove: live drag-move
        document.addEventListener('mousemove', function (e) {
            if (!STATE._isDragging || STATE.movingShapeIdx === null) return;
            var p  = getSvgCoords(e);
            var dx = p.x - STATE._moveStartX;
            var dy = p.y - STATE._moveStartY;

            STATE.shapes[STATE.movingShapeIdx].points = STATE._moveOriginalPoints.map(function (pt) {
                return { x: pt.x + dx, y: pt.y + dy };
            });

            // Live-update just the polygon and its controls
            var poly = svg.querySelector('[data-shape-idx="' + STATE.movingShapeIdx + '"]');
            if (poly) poly.setAttribute('points', pointsToSvgStr(STATE.shapes[STATE.movingShapeIdx].points));

            var container = document.getElementById('svgmap-canvas-container');
            var ctrl = container.querySelector('[data-for-shape="' + STATE.movingShapeIdx + '"]');
            if (ctrl) {
                var pos = svgCoordsToPixel(shapeCentroid(STATE.shapes[STATE.movingShapeIdx].points));
                ctrl.style.left = pos.left;
                ctrl.style.top  = pos.top;
            }
        });

        // Mouseup: finish drag-move
        document.addEventListener('mouseup', function (e) {
            if (!STATE._isDragging) return;
            STATE._isDragging      = false;
            STATE.movingShapeIdx   = null;
            STATE._moveOriginalPoints = [];
            var svgEl = document.getElementById('svgmap-svg');
            if (svgEl) svgEl.style.cursor = '';
            hideMoveModeHint();
            refreshShapes();
        });

        // Keyboard shortcuts
        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape') {
                if (STATE.drawing) cancelDrawing();
                if (STATE.movingShapeIdx !== null) cancelMove();
            }
            if (!STATE.drawing) return;
            if (e.key === ' ' || e.code === 'Space') {
                e.preventDefault();
                finishCurrentShape();
            }
        });
    }

    // ── Current path rendering (while drawing) ────────────────────────────
    function renderCurrentPath() {
        var svg    = document.getElementById('svgmap-svg');
        var pathEl = document.getElementById('svgmap-current-path');
        var dotsGrp = document.getElementById('svgmap-current-dots');

        if (!pathEl) {
            pathEl = document.createElementNS('http://www.w3.org/2000/svg', 'polyline');
            pathEl.setAttribute('id', 'svgmap-current-path');
            pathEl.setAttribute('fill', 'rgba(255,255,255,0.25)');
            pathEl.setAttribute('stroke', '#fff');
            pathEl.setAttribute('stroke-width', '2');
            pathEl.setAttribute('stroke-dasharray', '6,3');
            svg.appendChild(pathEl);
        }
        if (!dotsGrp) {
            dotsGrp = document.createElementNS('http://www.w3.org/2000/svg', 'g');
            dotsGrp.setAttribute('id', 'svgmap-current-dots');
            svg.appendChild(dotsGrp);
        }

        var pts = STATE.currentPoints;
        pathEl.setAttribute('points', pts.map(function (p) { return p.x + ',' + p.y; }).join(' '));

        dotsGrp.innerHTML = '';
        pts.forEach(function (p) {
            var c = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
            c.setAttribute('cx', p.x);
            c.setAttribute('cy', p.y);
            c.setAttribute('r', '5');
            c.setAttribute('fill', '#fff');
            c.setAttribute('stroke', '#333');
            c.setAttribute('stroke-width', '1.5');
            dotsGrp.appendChild(c);
        });
    }

    function clearCurrentPath() {
        var el = document.getElementById('svgmap-current-path');
        if (el) el.remove();
        var dots = document.getElementById('svgmap-current-dots');
        if (dots) dots.remove();
    }

    // ── Drawing mode ─────────────────────────────────────────────────────
    function startDrawing() {
        STATE.drawing       = true;
        STATE.currentPoints = [];
        var btn  = document.getElementById('btn-svgmap-draw');
        var hint = document.getElementById('svgmap-draw-hint');
        btn.classList.add('active');
        hint.style.display = 'inline';
        document.getElementById('svgmap-svg').style.cursor = 'crosshair';
        hideAllPanels();
    }

    function stopDrawing() {
        STATE.drawing = false;
        var btn  = document.getElementById('btn-svgmap-draw');
        var hint = document.getElementById('svgmap-draw-hint');
        btn.classList.remove('active');
        hint.style.display = 'none';
        document.getElementById('svgmap-svg').style.cursor = '';
    }

    function finishCurrentShape() {
        if (STATE.currentPoints.length < 3) {
            alert('Narysuj co najmniej 3 punkty kształtu.');
            return;
        }
        stopDrawing();
        clearCurrentPath();

        var newShape = {
            id: 'shape_' + Date.now(),
            points: STATE.currentPoints.slice(),
            property_id: null,
            property_title: '',
            property_url: '',
            property_status: 'wolne',
            property_img_name: '',
            tooltip_side: 'right'
        };
        STATE.shapes.push(newShape);
        STATE.pendingShapeIdx = STATE.shapes.length - 1;
        STATE.currentPoints = [];

        refreshShapes();
        showPropertySelectPanel(STATE.pendingShapeIdx);
    }

    function cancelDrawing() {
        stopDrawing();
        clearCurrentPath();
        STATE.currentPoints = [];
    }

    function resetDrawingState() {
        cancelDrawing();
        cancelMove();
        STATE.pendingShapeIdx = null;
        STATE.editingShapeIdx = null;
        hideAllPanels();
    }

    // ── Move mode ─────────────────────────────────────────────────────────
    function cancelMove() {
        if (STATE.movingShapeIdx === null) return;
        STATE.shapes[STATE.movingShapeIdx].points = STATE._moveOriginalPoints.slice();
        STATE.movingShapeIdx  = null;
        STATE._isDragging     = false;
        STATE._moveOriginalPoints = [];
        var svgEl = document.getElementById('svgmap-svg');
        if (svgEl) svgEl.style.cursor = '';
        hideMoveModeHint();
        refreshShapes();
    }

    function showMoveModeHint(shapeIdx) {
        var hint = document.getElementById('svgmap-move-hint');
        if (!hint) return;
        var name = STATE.shapes[shapeIdx].property_title || ('Kształt ' + (shapeIdx + 1));
        hint.textContent = 'Kliknij i przeciągnij kształt „' + name + '". Naciśnij Esc, aby anulować.';
        hint.style.display = 'inline';
    }

    function hideMoveModeHint() {
        var hint = document.getElementById('svgmap-move-hint');
        if (hint) hint.style.display = 'none';
    }

    // ── Save button visibility ────────────────────────────────────────────
    function updateSaveButton() {
        var btn = document.getElementById('btn-svgmap-save');
        if (!btn) return;
        // Show save button as soon as we have a bitmap loaded (allow saving
        // bitmap-only selection) or any shape.
        btn.style.display = (STATE.imageId || STATE.shapes.length > 0) ? 'inline-block' : 'none';
    }

    // ── Shapes rendering ──────────────────────────────────────────────────
    function pointsToSvgStr(points) {
        return points.map(function (p) { return p.x + ',' + p.y; }).join(' ');
    }

    function shapeCentroid(points) {
        var x = 0, y = 0;
        points.forEach(function (p) { x += p.x; y += p.y; });
        return { x: x / points.length, y: y / points.length };
    }

    // Convert SVG natural-coord point to pixel position within #svgmap-canvas-container
    function svgCoordsToPixel(svgPt) {
        var svg       = document.getElementById('svgmap-svg');
        var container = document.getElementById('svgmap-canvas-container');
        var vb        = svg.viewBox.baseVal;
        if (!vb || !vb.width) return { left: '50%', top: '50%' };

        var svgRect = svg.getBoundingClientRect();
        var cRect   = container.getBoundingClientRect();

        // SVG is same aspect ratio as viewBox (inline-block container → no letterboxing)
        var scaleX = svgRect.width  / vb.width;
        var scaleY = svgRect.height / vb.height;
        var scale  = Math.min(scaleX, scaleY);

        var offsetX = (svgRect.width  - vb.width  * scale) / 2;
        var offsetY = (svgRect.height - vb.height * scale) / 2;

        var pixX = (svgRect.left - cRect.left) + offsetX + svgPt.x * scale;
        var pixY = (svgRect.top  - cRect.top)  + offsetY + svgPt.y * scale;

        return { left: pixX + 'px', top: pixY + 'px' };
    }

    function refreshShapes() {
        var svg = document.getElementById('svgmap-svg');
        svg.querySelectorAll('[data-shape-id]').forEach(function (el) { el.remove(); });

        var container = document.getElementById('svgmap-canvas-container');
        container.querySelectorAll('.svgmap-shape-controls').forEach(function (el) { el.remove(); });

        STATE.shapes.forEach(function (shape, idx) {
            renderShape(shape, idx);
        });

        updateSaveButton();
    }

    function renderShape(shape, idx) {
        var svg   = document.getElementById('svgmap-svg');
        var color = STATUS_COLORS[shape.property_status] || '#ffffff';

        var poly = document.createElementNS('http://www.w3.org/2000/svg', 'polygon');
        poly.setAttribute('data-shape-id',  shape.id);
        poly.setAttribute('data-shape-idx', idx);
        poly.setAttribute('points', pointsToSvgStr(shape.points));
        poly.setAttribute('fill', color);
        poly.setAttribute('fill-opacity', shape.property_id ? '0.3' : '0.2');
        poly.setAttribute('stroke', color);
        poly.setAttribute('stroke-width', '2');
        poly.setAttribute('stroke-opacity', '0.8');
        svg.appendChild(poly);

        // Control buttons (position absolute near centroid)
        var centroid = shapeCentroid(shape.points);
        var pos = svgCoordsToPixel(centroid);

        var container = document.getElementById('svgmap-canvas-container');
        var controls  = document.createElement('div');
        controls.className = 'svgmap-shape-controls';
        controls.setAttribute('data-for-shape', idx);
        controls.style.cssText = [
            'position:absolute',
            'z-index:20',
            'transform:translate(-50%,-50%)',
            'display:flex',
            'flex-direction:column',
            'gap:3px',
            'pointer-events:auto'
        ].join(';');
        controls.style.left = pos.left;
        controls.style.top  = pos.top;

        var btns = [
            { label: 'Edytuj',  cls: 'btn-warning',  fn: function () { openEditShape(idx); } },
            { label: 'Kopiuj',  cls: 'btn-info',      fn: function () { copyShape(idx); } },
            { label: 'Przesuń', cls: 'btn-secondary', fn: function () { enterMoveMode(idx); } },
            { label: 'Usuń',    cls: 'btn-danger',    fn: function () { deleteShape(idx); } }
        ];

        btns.forEach(function (b) {
            var btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'btn btn-xs ' + b.cls;
            btn.textContent = b.label;
            btn.addEventListener('click', b.fn);
            controls.appendChild(btn);
        });

        container.appendChild(controls);
    }

    // ── Copy shape ────────────────────────────────────────────────────────
    function copyShape(idx) {
        var src    = STATE.shapes[idx];
        var offset = 20;
        var copy   = {
            id: 'shape_' + Date.now(),
            points: src.points.map(function (p) { return { x: p.x + offset, y: p.y + offset }; }),
            property_id:       src.property_id,
            property_title:    src.property_title,
            property_url:      src.property_url,
            property_status:   src.property_status,
            property_img_name: src.property_img_name,
            tooltip_side:      src.tooltip_side
        };
        STATE.shapes.push(copy);
        hideAllPanels();
        refreshShapes();
    }

    // ── Move shape ────────────────────────────────────────────────────────
    function enterMoveMode(idx) {
        if (STATE.drawing) cancelDrawing();
        hideAllPanels();
        STATE.movingShapeIdx     = idx;
        STATE._isDragging        = false;
        STATE._moveOriginalPoints = STATE.shapes[idx].points.map(function (p) { return { x: p.x, y: p.y }; });

        document.getElementById('svgmap-svg').style.cursor = 'move';
        showMoveModeHint(idx);
    }

    // ── Delete shape ──────────────────────────────────────────────────────
    function deleteShape(idx) {
        if (!confirm('Czy napewno chcesz usunąć wybrany kształt?')) return;
        STATE.shapes.splice(idx, 1);
        hideAllPanels();
        STATE.pendingShapeIdx = null;
        STATE.editingShapeIdx = null;
        refreshShapes();
    }

    // ── Panels ────────────────────────────────────────────────────────────
    function hideAllPanels() {
        ['svgmap-panel-property', 'svgmap-panel-tooltip', 'svgmap-panel-edit'].forEach(function (id) {
            var el = document.getElementById(id);
            if (el) el.style.display = 'none';
        });
    }

    function positionPanel(panelEl, shapeIdx) {
        if (!panelEl || shapeIdx === null || shapeIdx === undefined) return;
        var shape    = STATE.shapes[shapeIdx];
        var centroid = shapeCentroid(shape.points);
        var pos = svgCoordsToPixel(centroid);
        panelEl.style.left      = pos.left;
        panelEl.style.top       = pos.top;
        panelEl.style.transform = 'translate(-50%, 10px)';
    }

    function showPropertySelectPanel(shapeIdx) {
        hideAllPanels();
        var panel = document.getElementById('svgmap-panel-property');
        if (!panel) return;
        positionPanel(panel, shapeIdx);
        panel.style.display = 'block';
        var select = document.getElementById('svgmap-prop-select');
        select.value = STATE.shapes[shapeIdx].property_id || '';
    }

    function showTooltipPanel(shapeIdx) {
        hideAllPanels();
        var panel = document.getElementById('svgmap-panel-tooltip');
        if (!panel) return;
        positionPanel(panel, shapeIdx);
        panel.style.display = 'block';
        var side = STATE.shapes[shapeIdx].tooltip_side;
        document.getElementById('svgmap-tooltip-left').classList.toggle('active',  side === 'left');
        document.getElementById('svgmap-tooltip-right').classList.toggle('active', side === 'right');
    }

    function openEditShape(idx) {
        if (STATE.movingShapeIdx !== null) return;
        STATE.editingShapeIdx = idx;
        hideAllPanels();
        var panel = document.getElementById('svgmap-panel-edit');
        if (!panel) return;
        positionPanel(panel, idx);
        panel.style.display = 'block';

        var shape  = STATE.shapes[idx];
        var select = document.getElementById('svgmap-edit-prop-select');
        select.value = shape.property_id || '';
        document.getElementById('svgmap-edit-tooltip-left').classList.toggle('active',  shape.tooltip_side === 'left');
        document.getElementById('svgmap-edit-tooltip-right').classList.toggle('active', shape.tooltip_side === 'right');
    }

    // ── Confirm handlers (called from HTML onclick) ───────────────────────
    window.svgMapConfirmProperty = function () {
        var idx    = STATE.pendingShapeIdx;
        var select = document.getElementById('svgmap-prop-select');
        var propId = parseInt(select.value, 10);
        if (!propId) { alert('Wybierz nieruchomość.'); return; }

        var prop = STATE.properties.find(function (p) { return p.id == propId; });
        if (!prop) return;

        var s = STATE.shapes[idx];
        s.property_id        = propId;
        s.property_title     = prop.title;
        s.property_url       = prop.url;
        s.property_status    = prop.house_status || 'wolne';
        s.property_img_name  = prop.img_name || '';

        refreshShapes();
        showTooltipPanel(idx);
    };

    window.svgMapConfirmTooltip = function (side) {
        var idx = (STATE.pendingShapeIdx !== null) ? STATE.pendingShapeIdx : STATE.editingShapeIdx;
        if (idx === null) return;
        STATE.shapes[idx].tooltip_side = side;
        hideAllPanels();
        STATE.pendingShapeIdx = null;
        refreshShapes();
    };

    window.svgMapConfirmEdit = function () {
        var idx = STATE.editingShapeIdx;
        if (idx === null) return;
        var select = document.getElementById('svgmap-edit-prop-select');
        var propId = parseInt(select.value, 10);
        if (propId) {
            var prop = STATE.properties.find(function (p) { return p.id == propId; });
            if (prop) {
                var s = STATE.shapes[idx];
                s.property_id       = propId;
                s.property_title    = prop.title;
                s.property_url      = prop.url;
                s.property_status   = prop.house_status || 'wolne';
                s.property_img_name = prop.img_name || '';
            }
        }
        var side = document.getElementById('svgmap-edit-tooltip-left').classList.contains('active') ? 'left' : 'right';
        STATE.shapes[idx].tooltip_side = side;
        hideAllPanels();
        STATE.editingShapeIdx = null;
        refreshShapes();
    };

    // ── Save ──────────────────────────────────────────────────────────────
    function saveMap() {
        var btn = document.getElementById('btn-svgmap-save');
        btn.disabled = true;
        btn.textContent = 'Zapisywanie…';

        var body = new URLSearchParams();
        body.append('action',       'save_svg_map');
        body.append('image_id',     STATE.imageId);
        body.append('image_name',   STATE.imageName);
        body.append('image_width',  STATE.imageWidth);
        body.append('image_height', STATE.imageHeight);
        body.append('shapes',       JSON.stringify(STATE.shapes));

        function showError(msg) {
            btn.disabled = false;
            btn.textContent = 'Błąd zapisu';
            btn.classList.remove('btn-success');
            btn.classList.add('btn-danger');
            console.error('[svg-map] save failed:', msg);
            try { alert('Nie udało się zapisać mapy: ' + msg); } catch (e) {}
            setTimeout(function () {
                btn.textContent = 'Zapisz mapę';
                btn.classList.remove('btn-danger');
                btn.classList.add('btn-success');
            }, 4000);
        }

        fetch(STATE.saveUrl, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            credentials: 'same-origin',
            body: body.toString()
        })
        .then(function (r) {
            return r.text().then(function (txt) {
                var data;
                try { data = JSON.parse(txt); }
                catch (e) {
                    throw new Error('Niepoprawna odpowiedź serwera (HTTP ' + r.status + '): ' + txt.substring(0, 200));
                }
                if (!r.ok && !data.success) {
                    throw new Error(data.error || ('HTTP ' + r.status));
                }
                return data;
            });
        })
        .then(function (data) {
            if (data && data.success) {
                btn.disabled = false;
                btn.textContent = 'Zapisano!';
                btn.classList.replace('btn-success', 'btn-outline-success');
                setTimeout(function () {
                    btn.textContent = 'Zapisz mapę';
                    btn.classList.replace('btn-outline-success', 'btn-success');
                }, 2500);
            } else {
                showError((data && data.error) || 'nieznany błąd');
            }
        })
        .catch(function (err) {
            showError(err && err.message ? err.message : 'błąd połączenia');
        });
    }

}());
