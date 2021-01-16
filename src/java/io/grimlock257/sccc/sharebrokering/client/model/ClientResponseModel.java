package io.grimlock257.sccc.sharebrokering.client.model;

/**
 * Represent a client side login model
 *
 * @author Adam Watson
 */
public class ClientResponseModel {

    private boolean isSuccessful;
    private String message;

    public ClientResponseModel(boolean isSuccessful, String message) {
        this.isSuccessful = isSuccessful;
        this.message = message;
    }

    public boolean isIsSuccessful() {
        return isSuccessful;
    }

    public String getMessage() {
        return message;
    }
}
