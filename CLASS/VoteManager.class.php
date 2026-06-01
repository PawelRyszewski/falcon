<?php
class VoteManager
{
    public static function getCategories()
    {
        $res = DatabaseManager::selectSql("SELECT * FROM llm_categories ORDER BY id ASC");
        return is_array($res) ? $res : [];
    }

    public static function getModel($id)
    {
        $id = (int)$id;
        $res = DatabaseManager::selectSql("SELECT * FROM ai_models WHERE id={$id} LIMIT 1");
        return $res ? $res[0] : null;
    }

    public static function getModelByName($name, $categoryId = null)
    {
        $name = addslashes($name);
        $query = "SELECT * FROM ai_models WHERE name='{$name}'";
        if ($categoryId !== null) {
            $query .= ' AND category_id=' . (int)$categoryId;
        }
        $query .= ' LIMIT 1';
        $res = DatabaseManager::selectSql($query);
        return $res ? $res[0] : null;
    }
	
    public static function getModelBySlug($slug)
    {
        $slug = addslashes($slug);
        $models = DatabaseManager::selectSql("SELECT * FROM ai_models");
        foreach ((is_array($models) ? $models : []) as $model) {
            if (self::slugify($model['name']) === $slug) {
                return $model;
            }
        }
        return null;
    }

    public static function slugify($text)
    {
        $text = iconv('UTF-8', 'ASCII//TRANSLIT', $text);
        $text = preg_replace('/[^a-zA-Z0-9]+/', '-', $text);
        $text = strtolower(trim($text, '-'));
        return $text;
    }

    public static function getCategoryName($id)
    {
        $id = (int)$id;
        $res = DatabaseManager::selectSql("SELECT name FROM llm_categories WHERE id={$id} LIMIT 1");
        return $res ? $res[0]['name'] : '';
    }

    public static function castVote($modelId, $categoryId, $ip)
    {
        $modelId = (int)$modelId;
        $categoryId = (int)$categoryId;
        $ip = addslashes($ip);
        $exists = DatabaseManager::selectSql("SELECT id FROM votes WHERE category_id={$categoryId} AND user_ip='{$ip}' LIMIT 1");
        if (!$exists) {
            DatabaseManager::insertSql('votes', [
                'model_id' => $modelId,
                'category_id' => $categoryId,
                'user_ip' => $ip
            ]);
			DatabaseManager::incrementValue('ai_models', 'votes_site = votes_site + 1', 'id=' . $modelId);
            return true;
        }
        return false;
    }
	

    public static function refreshCategoryFromJson($cat, $skipLogo = false)
    {
        $jsonPath = dirname(__DIR__) . '/' . ltrim($cat['json_file'] ?? '', '/');
        $scores = [];
        if (!empty($cat['json_file']) && file_exists($jsonPath)) {
            $json = json_decode(file_get_contents($jsonPath), true);
            if (is_array($json)) {
                $seen = [];
                $filtered = [];
                foreach ($json as $row) {
                    if (!isset($row['Model'])) {
                        continue;
                    }
                    $key = strtolower(trim($row['Model']));
                    if (isset($seen[$key])) {
                        continue;
                    }
                    $seen[$key] = true;
                    $filtered[] = $row;
                }
                $json = $filtered;				
				
                $max = (int)($cat['json_limit'] ?? 0);
				$allRows = $json;
                if ($max > 0) {
                     if (!empty($cat['json_top'])) {
                        $byVotes = $json;
                        usort($byVotes, function ($a, $b) {
                            return ($b['Votes'] ?? 0) <=> ($a['Votes'] ?? 0);
                        });
                        $topVotes = array_slice($byVotes, 0, $max);

                        $byScore = $json;
                        usort($byScore, function ($a, $b) {
                            return ($b['Score'] ?? 0) <=> ($a['Score'] ?? 0);
                        });
                        $topScore = array_slice($byScore, 0, $max);

                        $selected = [];
                        foreach (array_merge($topVotes, $topScore) as $row) {
                            if (!isset($row['Model']) || isset($selected[$row['Model']])) {
                                continue;
                            }
                            $selected[$row['Model']] = $row;
                        }
                        $json = array_values($selected);
                    } else {
                        $json = array_slice($json, 0, $max);
                    }
					
                    $existing = DatabaseManager::selectSql('SELECT name FROM ai_models WHERE category_id=' . (int)$cat['id']);
                    $existingNames = [];
                    foreach ((is_array($existing) ? $existing : []) as $ex) {
                        $existingNames[$ex['name']] = true;
                    }
                    $present = [];
                    foreach ($json as $row) {
                        if (isset($row['Model'])) {
                            $present[$row['Model']] = true;
                        }
                    }
                    foreach ($allRows as $row) {
                        if (!isset($row['Model'])) {
                            continue;
                        }
                        if (isset($existingNames[$row['Model']]) && !isset($present[$row['Model']])) {
                            $json[] = $row;
                        }
                    }
					
                }
                foreach ($json as $row) {
                    if (!isset($row['Model'])) {
                        continue;
                    }
                    $votesJson = (int)($row['Votes'] ?? 0);
                    $modelLink = $row['Link model'] ?? '';
                    $logoPath = $skipLogo ? '' : self::processLogo($row['Organization'] ?? '', $row['Link logo'] ?? '');
                    $model = self::getModelByName($row['Model'], $cat['id']);
                    if ($model) {
                        $update = ['votes_json' => $votesJson];
                        if ($modelLink) {
                            $update['model_link'] = $modelLink;
                        }
                        if (!$skipLogo && $logoPath) {
                            $update['image'] = $logoPath;
                        }
                        if (!empty($row['Description'])) {
                            $update['description'] = $row['Description'];
                        }
                        if (!empty($row['Meta title'])) {
                            $update['meta_title'] = $row['Meta title'];
                        }
                        if (!empty($row['Meta description'])) {
                            $update['meta_description'] = $row['Meta description'];
                        }
                        if (!empty($row['Meta keywords'])) {
                            $update['meta_keywords'] = $row['Meta keywords'];
                        }						
                        DatabaseManager::updateSql('ai_models', $update, 'id=' . $model['id']);
                        $modelId = $model['id'];
                    } elseif (!empty($cat['create_missing_models'])) {
                        $insert = [
                            'name' => $row['Model'],
                            'description' => $row['Description'] ?? '',
                            'image' => $skipLogo ? '' : $logoPath,
                            'organization' => $row['Organization'] ?? '',
                            'license' => $row['License'] ?? '',
							'model_link' => $modelLink,
                            'category_id' => $cat['id'],
                            'votes_json' => $votesJson,
                            'votes_site' => 0
                         ];
                        if (!empty($row['Meta title'])) {
                            $insert['meta_title'] = $row['Meta title'];
                        }
                        if (!empty($row['Meta description'])) {
                            $insert['meta_description'] = $row['Meta description'];
                        }
                        if (!empty($row['Meta keywords'])) {
                            $insert['meta_keywords'] = $row['Meta keywords'];
                        }
                        $modelId = DatabaseManager::insertSql('ai_models', $insert);						
                    } else {
                        continue;
                    }
                    $scores[$modelId] = (int)($row['Score'] ?? 0);
                }
            } else {
                error_log('Nieprawidłowy format JSON w ' . $jsonPath);
            }
        } else {
            if (!empty($cat['json_file'])) {
                error_log('Nie znaleziono pliku JSON: ' . $jsonPath);
            }
        }
        return $scores;
    }
	
    private static function processLogo($organization, $logoSource)
    {
        $organization = trim($organization);
        if ($organization === '') {
            return '';
        }
        $orgEsc = addslashes($organization);
        $existing = DatabaseManager::selectSql("SELECT name FROM images WHERE id_gallery=60 AND title='{$orgEsc}' LIMIT 1");
        if ($existing) {
            return '/uploads/' . $existing[0]['name'];
        }
        $existingModel = DatabaseManager::selectSql("SELECT image FROM ai_models WHERE organization='{$orgEsc}' AND image<>'' LIMIT 1");
        if ($existingModel) {
            return $existingModel[0]['image'];
        }
        if ($logoSource === '') {
            return '';
        }
        require_once __DIR__ . '/../admin/utils/php/functions.php';
        $uploadsDir = dirname(__DIR__) . '/uploads';
        $thumbDir = $uploadsDir . '/thumb';
        if (!is_dir($uploadsDir)) {
            mkdir($uploadsDir, 0777, true);
        }
        if (!is_dir($thumbDir)) {
            mkdir($thumbDir, 0777, true);
        }
        $fileName = generateFileName($organization);
        $imgPath  = $uploadsDir . '/' . $fileName;
        $thumbPath = $thumbDir . '/' . $fileName;
        try {
            /* ---------- 1. pobranie zawartości logo ---------- */
            if (preg_match('/^<svg/i', trim($logoSource))) {
                $content = $logoSource;                     // inline-SVG
            } else {
                $content = @file_get_contents($logoSource); // URL/plik
                if ($content === false) {
                    return '';
                }
            }

            /* ---------- 2. przygotowanie obiektu Imagick ---------- */
            $im = new \Imagick();
            $im->setBackgroundColor(new \ImagickPixel('transparent'));

            $isSvg = preg_match('/^<svg/i', trim($content));

            /* ---------- 3. jeśli SVG – napraw kolory  rasteryzuj HD ---------- */
            if ($isSvg) {
                libxml_use_internal_errors(true);
                $dom = new \DOMDocument();
                if ($dom->loadXML($content)) {
                    $root = $dom->documentElement;
                    if ($root->getAttribute('fill') === 'none') {
                        $root->removeAttribute('fill');          // usuwa przezroczystość
                    }
                    if (!$root->hasAttribute('fill')) {
                        $root->setAttribute('fill', '#000');     // domyślny czarny
                    }
                    $content = $dom->saveXML();
                }

                $im->setResolution(600, 600);      // wysoka DPI (ostrość)
                $im->readImageBlob($content);
            } else {
                $im->readImageBlob($content);       // PNG/JPG
            }

            /* ---------- 4. wspólne: trim  reset canvas ---------- */
            $im->trimImage(0);
            $im->setImagePage(0, 0, 0, 0);

            /* ---------- 5. skalowanie w dół do max 220×220 ---------- */
            if ($im->getImageWidth() > 450 || $im->getImageHeight() > 450) {
                $im->resizeImage(450, 450, \Imagick::FILTER_LANCZOS, 1, true);
            }

            /* ---------- 6. delikatne wyostrzenie ---------- */
            $im->unsharpMaskImage(0, 0.5, 1, 0);         
			
				

            // Create transparent canvas and center the resized image on it
            $canvas = new \Imagick();
            $canvas->newImage(250, 250, new \ImagickPixel('transparent'));
            $canvas->compositeImage(
                $im,
                \Imagick::COMPOSITE_OVER,
                (int) ((250 - $im->getImageWidth()) / 2),
                (int) ((250 - $im->getImageHeight()) / 2)
            );

            // Finally convert to WebP and save both full image and thumbnail
            $canvas->setImageFormat('webp');
			$canvas->setImageCompressionQuality(90);
            $canvas->writeImage($imgPath);
            $canvas->writeImage($thumbPath);

            $im->clear();
            $canvas->clear();
        } catch (\Exception $e) {
            return '';
        }
        DatabaseManager::insertSql('images', [
            'name' => $fileName,
            'title' => $organization,
            'id_gallery' => 60
        ]);
        return '/uploads/' . $fileName;
    }	

    public static function updateVotesSite($categoryId)
    {
        $categoryId = (int)$categoryId;
        DatabaseManager::updateSql('ai_models', ['votes_site' => 0], 'category_id=' . $categoryId);
        $dbVotes = DatabaseManager::selectSql("SELECT model_id, COUNT(*) as v FROM votes WHERE category_id={$categoryId} GROUP BY model_id");
        foreach ((is_array($dbVotes) ? $dbVotes : []) as $v) {
            DatabaseManager::updateSql('ai_models', ['votes_site' => (int)$v['v']], 'id=' . $v['model_id']);
        }
    }

    public static function getCategoriesWithResults()
    {
        $categories = self::getCategories();
        if (!is_array($categories)) {
            $categories = [];
        }
        foreach ($categories as &$cat) {
            $scores = self::refreshCategoryFromJson($cat);
            self::updateVotesSite($cat['id']);            
            $models = DatabaseManager::selectSql("SELECT * FROM ai_models WHERE category_id={$cat['id']}");
			$cat['results'] = [];
            foreach ((is_array($models) ? $models : []) as $model) {
                 $cat['results'][$model['id']] = [
                    'model' => $model,
                    'score' => $scores[$model['id']] ?? 0,
                    'votes' => (int)$model['votes_json'] + (int)$model['votes_site']
                ];              
            }
        }
        return $categories;
    }

    private static function collectTotals()
    {
        $categories = self::getCategoriesWithResults();
        $totals = [];
        foreach ($categories as $cat) {
            if (!isset($cat['results']) || !is_array($cat['results'])) {
                continue;
            }
            foreach ($cat['results'] as $modelId => $info) {
                if (!isset($totals[$modelId])) {
                    $totals[$modelId] = [
                        'model' => $info['model'],
                        'votes' => 0,
                        'score' => 0,
                        'category' => $cat['name']
                    ];
                }
                $totals[$modelId]['votes'] += $info['votes'];
                $totals[$modelId]['score'] += $info['score'];				
            }
        }
        return $totals;
    }

    private static function prepareTop($totals, $limit)
    {
        $totals = array_slice($totals, 0, $limit);
        $out = [];
        foreach ($totals as $item) {
            $model = $item['model'];
            $model['votes'] = $item['votes'];
            $model['score'] = $item['score'];
            $model['category_name'] = $item['category'];
            $model['slug'] = self::slugify($model['name']);
            $out[] = $model;
        }
        return $out;
    }
    public static function getTopModelsByVotes($limit = 5)
    {
        $totals = self::collectTotals();
        usort($totals, function ($a, $b) {
            return $b['votes'] <=> $a['votes'];
        });
        return self::prepareTop($totals, $limit);
    }

    public static function getTopModelsByScore($limit = 5)
    {
        $totals = self::collectTotals();
        usort($totals, function ($a, $b) {
            return $b['score'] <=> $a['score'];
        });
        return self::prepareTop($totals, $limit);
    }
}
?>