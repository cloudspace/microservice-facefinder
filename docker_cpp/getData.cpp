#define CURL_STATICLIB
#include <stdio.h>
#include <curl/curl.h>
#include <string>
#include <iostream>

size_t write_data(void *ptr, size_t size, size_t nmemb, FILE *stream)
{
  size_t written;
  written = fwrite(ptr, size, nmemb, stream);
  return written;
}

int main(int argc, char *argv[])
{
  std::string readBuffer;
  CURL *curl;
  FILE *fp;
  CURLcode res;
  char *url = argv[0];
  curl = curl_easy_init();
  if (curl)
  {
    curl_easy_setopt(curl, CURLOPT_URL, url);
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_data);
    curl_easy_setopt(curl, CURLOPT_WRITEDATA, &readBuffer);
    curl_easy_setopt (curl, CURLOPT_VERBOSE, 1L);
    res = curl_easy_perform(curl);
    curl_easy_cleanup(curl);
    std::cout << readBuffer << std::endl;
  }
  return 0;
}
