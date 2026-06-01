<div class="container-fluid">
  <div class="content">
    <div class="row mb-4">
      <div class="col-12 col-lg">
        <h1 class="main-title"><span>Ustawienia API</span></h1>
      </div>
      <div class="col d-flex align-items-end flex-column">
        <a href="/admin/start" class="mt-auto p-2">
          <button type="button" class="btn btn-primary">Powrót</button>
        </a>
      </div>
    </div>
  </div>
  <div class="row block-white">
    <div class="col-12">
      <form class="p-3" method="post">
        <input type="hidden" name="save_api_settings" value="1" />
        <div class="form-group">
          <label>Brave API Key</label>
          <input class="form-control" name="brave_key" value="{$settings.brave_key}" />
        </div>
        <div class="form-group">
          <label>Jina API Key</label>
          <input class="form-control" name="jina_key" value="{$settings.jina_key}" />
        </div>
        <div class="form-group">
          <label>DeepSeek API Key</label>
          <input class="form-control" name="deepseek_key" value="{$settings.deepseek_key}" />
        </div>
        <div class="form-group">
          <label>GPT-4.1-mini API Key</label>
          <input class="form-control" name="gpt41_key" value="{$settings.gpt41_key}" />
        </div>
        <div class="form-group">
          <label>Usługa wyszukiwania</label>
          <select class="form-control" name="search_service">
            <option value="brave" {if $settings.search_service == 'brave'}selected{/if}>Brave</option>
            <option value="jina" {if $settings.search_service == 'jina'}selected{/if}>Jina</option>
            <option value="both" {if $settings.search_service == 'both'}selected{/if}>Oba</option>
          </select>
        </div>
        <div class="form-group">
          <label>Usługa generowania treści</label>
          <select class="form-control" name="gen_service">
            <option value="deepseek" {if $settings.gen_service == 'deepseek'}selected{/if}>DeepSeek</option>
            <option value="gpt-4.1-mini" {if $settings.gen_service == 'gpt-4.1-mini'}selected{/if}>GPT-4.1-mini</option>
          </select>
        </div>
        <div class="form-group">
          <label>System prompt</label>
          <textarea class="form-control" name="system_prompt" rows="5">{$settings.system_prompt}</textarea>
        </div>
        <button type="submit" class="btn btn-success">Zapisz</button>
      </form>
    </div>
  </div>
</div>