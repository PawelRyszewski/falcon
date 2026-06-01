<li class="nav-item{if $node.children|@count > 0} dropdown{/if}">
  <a class="nav-link{if $node.children|@count > 0} dropdown-toggle{/if}" href="/{$node.url}" title="{$node.title}" {if $node.children|@count > 0} data-bs-toggle="dropdown" role="button" aria-expanded="false"{/if}>{$node.title}</a>
  {if $node.children|@count > 0}
  <ul class="dropdown-menu">
    {foreach from=$node.children item=c}
      {include file='partials/menu_item.tpl' node=$c}
    {/foreach}
  </ul>
  {/if}
</li>
