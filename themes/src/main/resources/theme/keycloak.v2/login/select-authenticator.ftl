<#import "template.ftl" as layout>

<@layout.registrationLayout displayInfo=false; section>
    <!-- template: select-authenticator.ftl -->

    <#if section = "header" || section = "show-username">
        <#if section = "header">
            ${msg("loginChooseAuthenticator")}
        </#if>

    <#elseif section = "form">
        <ul class="${properties.kcSelectAuthListClass!}" role="list">
            <#list auth.authenticationSelections as authenticationSelection>
                <#assign formId = "kc-select-credential-form-" + authenticationSelection?index>

                <li class="${properties.kcSelectAuthListItemWrapperClass!}">
                    <form id="${formId}"
                          class="${properties.kcFormClass!}"
                          action="${url.loginAction}"
                          method="post">
                        <input type="hidden"
                               name="authenticationExecution"
                               value="${authenticationSelection.authExecId}">
                    </form>

                    <div role="button"
                         class="${properties.kcSelectAuthListItemClass!}"
                         data-form-id="${formId}"
                         tabindex="0">
                        <div class="pf-v5-c-data-list__item-content pf-v5-u-flex-wrap-wrap">
                            <div class="${properties.kcSelectAuthListItemIconClass!}">
                                <i class="${properties['${authenticationSelection.iconCssClass}']!authenticationSelection.iconCssClass} ${properties.kcSelectAuthListItemIconPropertyClass!}"></i>
                            </div>

                            <div class="${properties.kcSelectAuthListItemBodyClass!}">
                                <h2 class="${properties.kcSelectAuthListItemHeadingClass!}">
                                    ${msg('${authenticationSelection.displayName}')}
                                </h2>
                            </div>

                            <div class="${properties.kcSelectAuthListItemDescriptionClass!}">
                                ${msg('${authenticationSelection.helpText}')}
                            </div>
                        </div>

                        <div class="${properties.kcSelectAuthListItemFillClass!}">
                            <i class="${properties.kcSelectAuthListItemArrowIconClass!}"
                               aria-hidden="true"></i>
                        </div>
                    </div>
                </li>
            </#list>
        </ul>

        <script nonce="${cspNonce}">
            document.querySelectorAll("[data-form-id]").forEach((element) => {
                const submitForm = () => {
                    const formId = element.dataset.formId;
                    const form = document.getElementById(formId);

                    if (form) {
                        form.requestSubmit();
                    }
                };

                element.addEventListener("click", submitForm);

                element.addEventListener("keydown", (event) => {
                    if (event.key === "Enter" || event.key === " ") {
                        event.preventDefault();
                        submitForm();
                    }
                });
            });
        </script>
    </#if>
</@layout.registrationLayout>
