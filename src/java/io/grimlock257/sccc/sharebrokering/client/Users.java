package io.grimlock257.sccc.sharebrokering.client;

import io.grimlock257.sccc.sharebrokering.client.model.ClientResponseModel;
import io.grimlock257.sccc.ws.LoginResponse;
import io.grimlock257.sccc.ws.ShareBrokering;
import io.grimlock257.sccc.ws.ShareBrokering_Service;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;

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
     * @return A ClientResponseModel containing boolean of success, and a message representing an HTML dialog box with the appropriate message within (success or failure)
     */
    public ClientResponseModel register(String firstName, String lastName, String username, String password, String currency) {
        if (firstName == null || lastName == null || username == null || password == null || currency == null) {
            return new ClientResponseModel(false, "<div class='bg-danger p-2 mb-3'>Sorry, something went wrong. It appears some form information is missing - please try again.</div>");
        }

        Boolean registerSuccess = port.registerUser(firstName, lastName, username, password, currency);

        if (registerSuccess) {
            return new ClientResponseModel(true, "<div class='bg-success p-2 mb-3'>You've successfully registered!</div>");
        } else {
            return new ClientResponseModel(false, "<div class='bg-danger p-2 mb-3'>Your registration has failed. Please try again.</div>");
        }
    }

    /**
     * Attempt to log the user in with the provided details
     *
     * @param response The response object from the call site page
     * @param username The supplied username
     * @param password The supplied password
     * @return A ClientResponseModel containing boolean of success, and a message representing an HTML dialog box with the appropriate message within (success or failure)
     */
    public ClientResponseModel login(HttpServletResponse response, String username, String password) {
        if (username == null || password == null) {
            return new ClientResponseModel(false, "<div class='bg-danger p-2 mb-3'>Sorry, something went wrong. It appears some form information is missing - please try again.</div>");
        }

        LoginResponse loginResponse = port.loginUser(username, password);

        if (loginResponse.isSuccessful()) {
            Cookie guidCookie = new Cookie("guid", loginResponse.getGuid());
            guidCookie.setMaxAge(60 * 60 * 24);

            Cookie roleCookie = new Cookie("role", loginResponse.getRole().toString());
            roleCookie.setMaxAge(60 * 60 * 24);

            response.addCookie(guidCookie);
            response.addCookie(roleCookie);

            return new ClientResponseModel(true, "<div class='bg-success p-2 mb-3'>You've successfully logged in!</div>");
        } else {
            return new ClientResponseModel(false, "<div class='bg-danger p-2 mb-3'>Your login has failed. Please try again.</div>");
        }
    }

    /**
     * Log the user out by deleting their cookies
     *
     * @param response The response object from the call site page
     */
    public void logout(HttpServletResponse response) {
        Cookie guidCookie = new Cookie("guid", null);
        guidCookie.setMaxAge(0);

        Cookie roleCookie = new Cookie("role", null);
        roleCookie.setMaxAge(0);

        response.addCookie(guidCookie);
        response.addCookie(roleCookie);
    }
}
