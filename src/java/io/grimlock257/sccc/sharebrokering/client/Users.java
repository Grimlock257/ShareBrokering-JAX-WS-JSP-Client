package io.grimlock257.sccc.sharebrokering.client;

import io.grimlock257.sccc.ws.LoginResponse;
import io.grimlock257.sccc.ws.ShareBrokering;
import io.grimlock257.sccc.ws.ShareBrokering_Service;

/**
 * Users
 *
 * Contains methods regarding users such as retrieving user information, registration and logging in
 *
 * @author Adam Watson
 */
public class Users {

    private static Users instance = null;

    ShareBrokering_Service service;
    ShareBrokering port;

    /**
     * Private constructor to prevent instantiation
     */
    private Users() {
        // Create reference to the web service
        service = new ShareBrokering_Service();
        port = service.getShareBrokeringPort();
    }

    /**
     * Get the instance of the Users singleton
     *
     * @return The instance of the Users
     */
    public static Users getInstance() {

        if (instance == null) {
            instance = new Users();
        }

        return instance;
    }

    /**
     * Attempt to register a new user with the provided information
     *
     * @param firstName The users first name
     * @param lastName The users last name
     * @param username The users username
     * @param password The users password
     * @param currency The users fund currency
     * @return A string representing an HTML dialog box with the appropriate message within (success or failure)
     */
    public String register(String firstName, String lastName, String username, String password, String currency) {
        if (firstName == null || lastName == null || username == null || password == null || currency == null) {
            return "<div class='bg-danger p-2 mb-3'>Sorry, something went wrong. It appears some form information is missing - please try again.</div>";
        }

        Boolean registerSuccess = port.registerUser(firstName, lastName, username, password, currency);

        if (registerSuccess) {
            return "<div class='bg-success p-2 mb-3'>You've successfully registered!</div>";
        } else {
            return "<div class='bg-danger p-2 mb-3'>Your registration has failed. Please try again. </div>";
        }
    }
}
