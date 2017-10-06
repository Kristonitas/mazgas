### The following steps show how to launch a simple Node.js server that will host the test page

Node.js server is requred to load the .pde file, doing so straight from index.html will result in a [CORS](https://en.wikipedia.org/wiki/Cross-origin_resource_sharing) error. There are a lot of different ways to solve this problem, but this is one of the simpler ones.

* Download and install Node.js https://nodejs.org/en/download/

* Make sure that `node -v` and `npm -v` commands execute (and print out a version number) in the command prompt (terminal for non Windows OS)

* Install http-server package by execute `npm install http-server -g`

* Navigate to the project folder with the terminal and execute `http-server`. You should see the following or similar text:

```
Starting up http-server, serving ./
Available on:
  http://192.168.32.185:8080
  http://127.0.0.1:8080
Hit CTRL-C to stop the server
```

At this point open `localhost:8080` or `127.0.0.1:8080` in the browser.