#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>

#define MAX_PATH 512

static const char* LANG = "en";
static const char* DIR_PATH = "./StarRail_Data/StreamingAssets/DesignData/Windows/";
static const char* FONT_PAT = "SpriteOutput/UI/Fonts/RPG_CN.ttf";
static const char* LANG_PAT = "Korean";

unsigned char* find_pattern(
    unsigned char* data,
    size_t data_len,
    const unsigned char* pattern,
    size_t pattern_len
) {
    if (pattern_len == 0 || data_len < pattern_len) {
        return NULL;
    }

    for (size_t i = 0; i <= data_len - pattern_len; i++) {
        if (memcmp(data + i, pattern, pattern_len) == 0) {
            return data + i;
        }
    }

    return NULL;
}

size_t replace_bytes(
    unsigned char* content,
    size_t idx,
    const char* choice,
    int count
) {
    for (int i = 0; i < count; i++) {
        memcpy(content + idx, choice, 2);
        idx += 3;
    }

    return idx;
}

int main(void) {
    DIR *dir = opendir(DIR_PATH);
    if (!dir) {
        perror("opendir failed");
        return 1;
    }

    struct dirent *entry;

    while ((entry = readdir(dir)) != NULL) {
        char path[MAX_PATH];

        snprintf(
            path,
            sizeof(path),
            "%s%s",
            DIR_PATH,
            entry->d_name
        );

        FILE *f = fopen(path, "rb");
        if (!f) {
            continue;
        }

        fseek(f, 0, SEEK_END);
        long size = ftell(f);
        rewind(f);

        unsigned char* buf = malloc(size);
        if (!buf) {
            fclose(f);
            continue;
        }

        fread(buf, 1, size, f);
        fclose(f);

        unsigned char* p1 = find_pattern(
            buf, size,
            (const unsigned char*)FONT_PAT,
            strlen(FONT_PAT)
        );

        if (!p1) {
            free(buf);
            continue;
        }

        unsigned char* p2 = find_pattern(
            buf, size,
            (const unsigned char*)LANG_PAT,
            strlen(LANG_PAT)
        );

        if (!p2) {
            free(buf);
            continue;
        }

        size_t idx = (size_t)(p2 - buf);

        printf("found: %s\n", entry->d_name);
        printf("patching to en\n");

        idx += 10;
        idx += 4;
        idx = replace_bytes(buf, idx, LANG, 4);

        idx += 1;
        idx += 5;
        idx = replace_bytes(buf, idx, LANG, 2);

        idx += 1;
        idx += 5;
        idx = replace_bytes(buf, idx, LANG, 5);

        idx += 1;
        idx += 4;
        idx = replace_bytes(buf, idx, LANG, 2);

        FILE *w = fopen(path, "wb");
        if (w) {
            fwrite(buf, 1, size, w);
            fclose(w);
            printf("done.\n");
        }

        free(buf);
        closedir(dir);
        return 0;
    }

    closedir(dir);

    printf("no matching file found.\n");
    return 0;
}
