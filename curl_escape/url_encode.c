/* 2019 - ChillerDragon
 * Crappy url encode files
 * UNLICESED do what ever you want :)
 *
 * BUILDING:
 * make
 * ./url_encode src/ dst/
 */
#include <stdio.h>
#include <string.h>
#include <dirent.h>
#include <curl/curl.h>

void EscapeUrl(char *pBuf, int Size, const char *pStr)
{
	char *pEsc = curl_easy_escape(0, pStr, 0);
	strncpy(pBuf, pEsc, Size);
	curl_free(pEsc);
}

int IsSlash(char *pBuf, int Index)
{
    if(!pBuf[Index])
        return 1;
    if(pBuf[Index] != '/')
        return 0;
    return IsSlash(pBuf, Index+1);
}

void StripPath(char *pBuf)
{
    for(int i = 0; pBuf[i]; i++)
    {
        if(IsSlash(pBuf, i))
        {
            pBuf[i] = '\0';
            return;
        }
    }
}

int main(int argc, char *argv[])
{
    if (argc != 3)
    {
        printf("usage: %s <src-path> <dst-path>\n", argv[0]);
        return 0;
    }
    char aPath[1024];
    char aDstPath[1024];
    strncpy(aPath, argv[1], sizeof(aPath));
    strncpy(aDstPath, argv[2], sizeof(aDstPath));
    StripPath(aPath);
    StripPath(aDstPath);
    struct dirent *pDe;
    DIR *pDir = opendir(aPath);
    if(pDir == NULL)
    {
        printf("Error: failed to open directory '%s'.", aPath);
        return 1;
    }
    while ((pDe = readdir(pDir)) != NULL)
    {
        if (pDe->d_name[0] == '.')
        {
            printf("ignore '%s'\n", pDe->d_name);
            continue;
        }
        char aEncode[128];
        EscapeUrl(aEncode, sizeof(aEncode), pDe->d_name);
        printf("'%s' -> '%s'\n", pDe->d_name, aEncode);
        char aSrc[1024];
        char aDst[1024];
        snprintf(aSrc, sizeof(aSrc), "%s/%s", aPath, pDe->d_name);
        snprintf(aDst, sizeof(aDst), "%s/%s", aDstPath, aEncode);
        int ret = rename(aSrc, aDst);
        if(ret)
        {
            printf("Error: rename failed with error code=%d\n", ret);
            return 1;
        }
    }
    closedir(pDir);
    return 0;
}

