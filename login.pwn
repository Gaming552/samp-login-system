#include <a_samp>

const MAX_PLAYERS = 500;
new PlayerLoggedIn[MAX_PLAYERS];

public OnGameModeInit()
{
    for (new i = 0; i < MAX_PLAYERS; i++)
        PlayerLoggedIn[i] = false;

    SendClientMessageToAll(-1, "wlc nigga");

    LoadAccounts();

    return 1;
}

public OnPlayerConnect(playerid)
{
    SendClientMessage(playerid, -1, "Welcome to the server! Use /login to login in your account");

    PlayerLoggedIn[playerid] = false;

    return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    new cmd[64], params[64];
    sscanf(cmdtext, "s[64] s[64]", cmd, params);

    if (strcmp(cmd, "/login", true) == 0)
    {
        if (PlayerLoggedIn[playerid])
        {
            SendClientMessage(playerid, -1, "You are already logged in.");
            return 1;
        }

        if (strlen(params) == 0)
        {
            SendClientMessage(playerid, -1, "You dont use command correct, usage is /login <username> <password>");
            return 1;
        }

        if (AuthenticateAccount(playerid, params))
        {
            PlayerLoggedIn[playerid] = true;
            SendClientMessage(playerid, -1, "Login successful!");
            return 1;
        }
        else
        {
            SendClientMessage(playerid, -1, "Invalid username or password.");
            return 1;
        }
    }
    return 0;
}

public OnPlayerDisconnect(playerid, reason)
{
    PlayerLoggedIn[playerid] = false;
    return 1;
}

public LoadAccounts()
{
    new file = fopen("accs.txt", "r");

    if (file != INVALID_FILE)
    {
        new line[128], username[32], password[32];

        while (fgets(line, sizeof(line), file))
        {
            sscanf(line, "s[32] s[32]", username, password);
            AddAccount(username, password);
        }

        fclose(file);
    }
    else
    {
        printf("Failed to open accs.txt!");
    }

    return 1;
}

public AuthenticateAccount(playerid, params[])
{
    new file = fopen("accs.txt", "r");

    if (file != INVALID_FILE)
    {
        new line[128], username[32], password[32];

        while (fgets(line, sizeof(line), file))
        {
            sscanf(line, "s[32] s[32]", username, password);

            if (strcmp(username, gettok(params, 1, " ")) == 0 && strcmp(password, gettok(params, 2, " ")) == 0)
            {
                fclose(file);
                return true;
            }
        }

        fclose(file);
    }
    else
    {
        printf("Failed to open accs.txt!");
    }

    return false;
}

public AddAccount(username[], password[])
{
    new file = fopen("accs.txt", "a");

    if (file != INVALID_FILE)
    {
        fprintf(file, "%s:%s\n", username, password);
        fclose(file);
        return 1;
    }
    else
    {
        printf("Failed to open accs.txt!");
    }

    return 0;
}
