package io.grimlock257.sccc.sharebrokering.client;

import io.grimlock257.sccc.sharebrokering.client.model.ClientResponseModel;
import io.grimlock257.sccc.sharebrokering.client.model.UserSessionModel;
import io.grimlock257.sccc.ws.FundsResponse;
import io.grimlock257.sccc.ws.LoginResponse;
import io.grimlock257.sccc.ws.ShareBrokering;
import io.grimlock257.sccc.ws.ShareBrokering_Service;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.ws.WebServiceException;

/**
 * Users
 *
 * Contains methods regarding users such as retrieving user information, registration and logging in
 *
 * @author Adam Watson
 */
public class Users {

    private static Users instance = null;

    /**
     * Private constructor to prevent instantiation
     */
    private Users() {
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

        Boolean registerSuccess;

        try {
            registerSuccess = getPort().registerUser(firstName, lastName, username, password, currency);
        } catch (NullPointerException e) {
            return new ClientResponseModel(false, "<div class='bg-danger p-2 mb-3'>Oops, something went wrong connecting to the web service. Please try again.</div>");
        }

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

        LoginResponse loginResponse;

        try {
            loginResponse = getPort().loginUser(username, password);
        } catch (NullPointerException e) {
            return new ClientResponseModel(false, "<div class='bg-danger p-2 mb-3'>Oops, something went wrong connecting to the web service. Please try again.</div>");
        }

        if (loginResponse != null && loginResponse.isSuccessful()) {
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

    /**
     * Attempt to retrieve the users available funds
     *
     * @param guid The account of which to retrieve available funds for
     * @return A string representing an HTML dialog box with the appropriate message within (success or failure)
     */
    public String getAvailableFunds(String guid) {
        if (guid == null) {
            return "<div class='bg-danger p-2 mb-3'>Sorry, something went wrong. Please try again.</div>";
        }

        FundsResponse fundsResponse;

        try {
            fundsResponse = getPort().getUserFunds(guid);
        } catch (NullPointerException e) {
            return "<div class='bg-danger p-2 mb-3'>Oops, something went wrong connecting to the web service. Please try again.</div>";
        }

        if (fundsResponse == null) {
            return "<div class='bg-danger p-2 mb-3'>Sorry, something went wrong. Please try again.</div>";
        } else {
            return "<div class='py-2'>You have " + String.format("%.2f", fundsResponse.getAvailableFunds()) + " " + fundsResponse.getCurrency() + " available.</div>";
        }
    }

    /**
     * Attempt to deposit funds to the users account
     *
     * @param guid The account to which to deposit the funds
     * @param amountStr The amount to deposit
     * @return A string representing an HTML dialog box with the appropriate message within (success or failure)
     */
    public String depositFunds(String guid, String amountStr) {
        try {
            if (guid == null || amountStr == null) {
                return "<div class='bg-danger p-2 mb-3'>Sorry, something went wrong. It appears some form information is missing - please try again.</div>";
            }

            Double amount = Double.parseDouble(amountStr);

            if (amount < 0) {
                return "<div class='bg-danger p-2 mb-3'>Sorry, something went wrong. You cannot deposit an amount less than 0 - please try again.</div>";
            } else {
                Boolean depositSuccess;

                try {
                    depositSuccess = getPort().depositFunds(guid, amount);
                } catch (NullPointerException e) {
                    return "<div class='bg-danger p-2 mb-3'>Oops, something went wrong connecting to the web service. Please try again.</div>";
                }

                if (depositSuccess) {
                    return "<div class='bg-success p-2 mb-3'>You have successfully deposited " + amount + " to your account.</div>";
                } else {
                    return "<div class='bg-danger p-2 mb-3'>Your deposit has failed. Please try again. </div>";
                }
            }
        } catch (NumberFormatException e) {
            return "<div class='bg-danger p-2 mb-3'>Sorry, something went wrong. It appears a non-numeric value was entered - please try again.</div>";
        }
    }

    /**
     * Attempt to withdraw funds from the users account
     *
     * @param guid The account to which to withdraw the funds from
     * @param amountStr The amount to withdraw
     * @return A string representing an HTML dialog box with the appropriate message within (success or failure)
     */
    public String withdrawFunds(String guid, String amountStr) {
        try {
            if (guid == null || amountStr == null) {
                return "<div class='bg-danger p-2 mb-3'>Sorry, something went wrong. It appears some form information is missing - please try again.</div>";
            }

            Double amount = Double.parseDouble(amountStr);

            if (amount < 0) {
                return "<div class='bg-danger p-2 mb-3'>Sorry, something went wrong. You cannot withdraw an amount less than 0 - please try again.</div>";
            } else {
                Boolean withdrawSuccess;

                try {
                    withdrawSuccess = getPort().withdrawFunds(guid, amount);
                } catch (NullPointerException e) {
                    return "<div class='bg-danger p-2 mb-3'>Oops, something went wrong connecting to the web service. Please try again.</div>";
                }

                if (withdrawSuccess) {
                    return "<div class='bg-success p-2 mb-3'>You have successfully withdrawn " + amount + " from your account.</div>";
                } else {
                    return "<div class='bg-danger p-2 mb-3'>Your withdrawal has failed. Please try again. </div>";
                }
            }
        } catch (NumberFormatException e) {
            return "<div class='bg-danger p-2 mb-3'>Sorry, something went wrong. It appears a non-numeric value was entered - please try again.</div>";
        }
    }

    /**
     * Retrieve the session information from cookies
     *
     * @param request The request object from the call site page
     * @return The UserSessionModel if logged in, or null otherwise
     */
    public UserSessionModel getUserSessionDetails(HttpServletRequest request) {
        String guid = null;
        String role = null;

        Cookie[] cookies = request.getCookies();

        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equalsIgnoreCase("guid")) {
                    guid = cookie.getValue();
                }

                if (cookie.getName().equalsIgnoreCase("role")) {
                    role = cookie.getValue().toUpperCase();
                }
            }
        }

        if (guid != null && role != null) {
            return new UserSessionModel(guid, role);
        } else {
            return null;
        }
    }

    /**
     * Attempt to form a connection to the Share Brokering SOAP service
     *
     * @return A port connection to the web service, or null if failure
     */
    private ShareBrokering getPort() {
        try {
            // Create reference to the web service
            ShareBrokering_Service service = new ShareBrokering_Service();
            ShareBrokering port = service.getShareBrokeringPort();

            return port;
        } catch (WebServiceException e) {
            System.err.println("[JSP Client] WebServiceException connecting to SharesBrokering SOAP service. ShareBrokering port will throw NPE. " + e.getMessage());
        }

        return null;
    }
}
