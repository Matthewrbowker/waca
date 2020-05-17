{extends file="pagebase.tpl"}
{block name="content"}
    <div class="row">
        <div class="col-md-12" >
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">View request details <small class="text-muted">for request #{$requestId}</small></h1>
            </div>
        </div>
    </div>
    <div id="pageRequestLog">

        <div class="row">
            <!-- request details -->
            <div class="col-lg-6">
                {include file="view-request/request-info.tpl"}
                <div class="zoom-buttons">
                    <hr />

                    {include file="view-request/reservation-section.tpl"}

                    {block name="createButton"}

                        {if $requestIsReservedByMe && !$requestIsClosed && $creationHasChoice}
                            <div class="creationTypeOptions">
                                {if $canManualCreate}
                                    <div class="custom-control-inline custom-radio">
                                        <input type="radio" name="createMode" id="createModeManual" value="manual" class="custom-control-input"
                                               {if $currentUser->getCreationMode() == 0}checked="checked"{/if} />
                                        <label for="createModeManual" class="custom-control-label">Manual</label>
                                    </div>
                                {/if}
                                {if $canOauthCreate}
                                    <div class="custom-control-inline custom-radio">
                                        <input type="radio" name="createMode" id="createModeOauth" value="oauth" class="custom-control-input"
                                               {if $currentUser->getCreationMode() == 1}checked="checked"{/if}>
                                        <label for="createModeOauth" class="custom-control-label">Use my Wikimedia account</label>
                                    </div>
                                {/if}
                                {if $canBotCreate}
                                    <div class="custom-control-inline custom-radio">
                                        <input type="radio" name="createMode" id="createModeBot" value="bot" class="custom-control-input"
                                               {if $currentUser->getCreationMode() == 2}checked="checked"{/if}>
                                        <label for="createModeBot" class="custom-control-label">Use the bot</label>
                                    </div>
                                {/if}
                            </div>
                        {/if}
                        <h5>Create account</h5>
                        <div class="row">
                            {if $requestIsReservedByMe && !$requestIsClosed}
                                {if $canManualCreate}
                                    <div class="col-md-12 create-button-row {if $currentUser->getCreationMode() !== 0}d-none{/if}" id="createManual">
                                        {block name="manualcreationbutton"}{/block}
                                    </div>
                                {/if}
                                {if $canOauthCreate}
                                    <div class="col-md-12 create-button-row {if $currentUser->getCreationMode() !== 1}d-none{/if}" id="createOauth">
                                        {include file="view-request/createbuttons/auto.tpl" creationMode="oauth" }
                                    </div>
                                {/if}
                                {if $canBotCreate}
                                    <div class="col-md-12 create-button-row {if $currentUser->getCreationMode() !== 1}d-none{/if}" id="createBot">
                                        {include file="view-request/createbuttons/auto.tpl" creationMode="bot"}
                                    </div>
                                {/if}
                            {/if}
                        </div>
                        <hr />
                    {/block}

                    {block name="requestStatusButtons"}
                        {include file="view-request/request-status-buttons.tpl"}
                    {/block}

                    {block name="banSection"}{/block}
                </div>
            </div>
            <div class="col-lg-6">
                {include file="view-request/request-log.tpl"}
            </div>
        </div><!--/row-->

        {include file="view-request/username-section.tpl"}

        {block name="ipSection"}{/block}

        {block name="emailSection"}{/block}

        {block name="otherRequests"}
            <div class="row">
                <div class="col-md-6">
                    <h3>Other requests from this email address</h3>
                    {if $requestDataCleared}
                        <p class="text-muted">Email information cleared</p>
                    {else}
                        <p class="text-muted">Data currently not visible.</p>
                    {/if}
                </div>
                <div class="col-md-6">
                    <h3>Other requests from this IP address</h3>
                    {if $requestDataCleared}
                        <p class="text-muted">IP information cleared</p>
                    {else}
                        <p class="text-muted">Data currently not visible.</p>
                    {/if}
                </div>
            </div>
        {/block}
    </div>
{/block}