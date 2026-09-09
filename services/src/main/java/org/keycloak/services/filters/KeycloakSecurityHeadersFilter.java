package org.keycloak.services.filters;

import jakarta.annotation.Priority;
import jakarta.ws.rs.container.ContainerRequestContext;
import jakarta.ws.rs.container.ContainerResponseContext;
import jakarta.ws.rs.container.ContainerResponseFilter;
import jakarta.ws.rs.container.PreMatching;
import jakarta.ws.rs.ext.Provider;

import org.keycloak.headers.SecurityHeadersProvider;
import org.keycloak.models.KeycloakSession;
import org.keycloak.services.security.CspNonce;
import org.keycloak.utils.KeycloakSessionUtil;

@Provider
@PreMatching
@Priority(10)
public class KeycloakSecurityHeadersFilter implements ContainerResponseFilter {

    public static final String CSP_NONCE_ATTRIBUTE =
            KeycloakSecurityHeadersFilter.class.getName() + ".nonce";

    public static String getNonce(KeycloakSession session) {
        if (session == null) {
            return null;
        }

        Object nonce = session.getAttribute(CSP_NONCE_ATTRIBUTE);

        if (nonce == null) {
            nonce = CspNonce.generate();
            session.setAttribute(CSP_NONCE_ATTRIBUTE, nonce);
        }

        return nonce.toString();
    }

    @Override
    public void filter(
            ContainerRequestContext requestContext,
            ContainerResponseContext responseContext) {

        KeycloakSession session = KeycloakSessionUtil.getKeycloakSession();

        if (session != null) {
            // Ensure the nonce exists before security headers are generated.
            getNonce(session);

            SecurityHeadersProvider securityHeadersProvider =
                    session.getProvider(SecurityHeadersProvider.class);

            securityHeadersProvider.addHeaders(
                    requestContext,
                    responseContext
            );
        }
    }
}
