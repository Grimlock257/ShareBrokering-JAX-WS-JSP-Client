package io.grimlock257.sccc.sharebrokering.client.model;

/**
 * Represent a user session
 *
 * @author Adam Watson
 */
public class UserSessionModel {

    private String guid;
    private String role;

    public UserSessionModel(String guid, String role) {
        this.guid = guid;
        this.role = role;
    }

    public String getGuid() {
        return guid;
    }

    public String getRole() {
        return role;
    }
}
