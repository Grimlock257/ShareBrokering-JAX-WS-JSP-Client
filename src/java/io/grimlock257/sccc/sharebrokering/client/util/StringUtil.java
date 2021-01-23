package io.grimlock257.sccc.sharebrokering.client.util;

/**
 * StringUtil
 *
 * This class contains functions for dealing with Strings
 *
 * @author Adam Watson
 */
public class StringUtil {

    /**
     * Private constructor as this utility class shouldn't be instantiated
     */
    private StringUtil() {

    }

    /**
     * Check whether the provided string <b>is</b> null or of 0 length
     *
     * @param string The string to check
     * @return True when the provided string does <b>not</b> have a value
     */
    public static boolean isNullOrEmpty(String string) {
        return (string == null || string.trim().length() == 0);
    }
}
