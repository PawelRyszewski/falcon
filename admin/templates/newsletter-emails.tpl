<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-12 col-lg">
            <h1 class="main-title"><span>Treść wiadomości newslettera</span></h1>
        </div>
        <div class="col d-flex align-items-end flex-column">
            <a href="/admin/newsletter" class="mt-auto p-2">
                <button type="button" class="btn btn-primary">Powrót</button>
            </a>
        </div>
    </div>
    <div class="row block-white">
        <div class="col-12">
            <div class="content">
                <form method="POST">
                    {foreach from=$emails item=email}
                    <div class="border rounded p-3 mb-4">
                        <h5>{$email.label}</h5>
                        <div class="form-group mt-2">
                            <label>Tytuł wiadomości</label>
                            <input type="text" class="form-control" name="subject[{$email.type}]" value="{$email.subject}" required />
                        </div>
                        <div class="form-group mt-2">
                            <label>Treść</label>
                            <textarea name="body[{$email.type}]" class="form-control tinymce">{$email.body}</textarea>
                        </div>
                    </div>
                    {/foreach}
                    <button type="submit" name="save_emails" class="btn btn-success">Zapisz zmiany</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
{literal}
    tinymce.remove();
    tinymce.init({
        selector: '.tinymce',
        language: 'pl',
        width: '100%',
        height: 300
    });
{/literal}
</script>