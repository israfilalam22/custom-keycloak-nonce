package org.keycloak.services.security;

import java.security.SecureRandom;
import java.util.Base64;

public final class CspNonce {

    private static final SecureRandom RANDOM = new SecureRandom();

    private CspNonce() {
    }

    public static String generate() {
        byte[] bytes = new byte[32];
        RANDOM.nextBytes(bytes);
        return Base64.getEncoder().withoutPadding().encodeToString(bytes);
    }
}
