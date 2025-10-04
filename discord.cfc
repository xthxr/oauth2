component extends="oauth2" accessors="true" {

    property name="client_id" type="string";
    property name="client_secret" type="string";
    property name="authEndpoint" type="string";
    property name="accessTokenEndpoint" type="string";
    property name="redirect_uri" type="string";

    /**
    * Initializes the Discord OAuth2 component.
    * @client_id Your Discord application's client ID.
    * @client_secret Your Discord application's client secret.
    * @authEndpoint Discord authorization URL.
    * @accessTokenEndpoint Discord access token URL.
    * @redirect_uri The URL to redirect the user back to after authentication.
    **/
    public discord function init(
        required string client_id,
        required string client_secret,
        string authEndpoint = "https://discord.com/api/oauth2/authorize",
        string accessTokenEndpoint = "https://discord.com/api/oauth2/token",
        required string redirect_uri
    ){
        super.init(
            client_id           = arguments.client_id,
            client_secret       = arguments.client_secret,
            authEndpoint        = arguments.authEndpoint,
            accessTokenEndpoint = arguments.accessTokenEndpoint,
            redirect_uri        = arguments.redirect_uri
        );
        return this;
    }

    /**
    * Builds the redirect URL to send the user to Discord for authorization.
    * @state A random string for CSRF protection.
    * @scope An optional array of scopes (e.g., "identify", "email", "guilds").
    **/
    public string function buildRedirectToAuthURL(
        required string state,
        array scope = ["identify"]
    ){
        var sParams = {
            "response_type" = "code",
            "state"         = arguments.state,
            "client_id"     = variables.client_id,
            "redirect_uri"  = variables.redirect_uri
        };
        if (arrayLen(arguments.scope)) {
            structInsert(sParams, "scope", arrayToList(arguments.scope, " "));
        }
        return super.buildRedirectToAuthURL(sParams);
    }

    /**
    * Exchanges the authorization code for an access token from Discord.
    * @code The authorization code returned by Discord.
    **/
    public struct function makeAccessTokenRequest(
        required string code
    ){
        var aFormFields = [
            { name = "grant_type", value = "authorization_code" },
            { name = "code", value = arguments.code },
            { name = "redirect_uri", value = variables.redirect_uri },
            { name = "client_id", value = variables.client_id },
            { name = "client_secret", value = variables.client_secret }
        ];

        return super.makeAccessTokenRequest(
            code       = arguments.code,
            formfields = aFormFields
        );
    }

}
