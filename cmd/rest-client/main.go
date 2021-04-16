package main

import (
	"flag"
	"fmt"
	"io/ioutil"
	"net/http"
	"strings"

	log "github.com/sirupsen/logrus"
)

func main() {

	address := flag.String("server", "http://localhost:8085", "HTTP gateway url, e.g. http://localhost:8457")
	flag.Parse()
	fmt.Println("port:9000")
	var body string

	resp, err := http.Post(*address+"/v1/login", "application/json", strings.NewReader(fmt.Sprintf(`
		{
			"apiVersion":"v1",
			"emailID": "sjnjaiswal@gmail.com",
			"password":"password"
		}
	`)))
	if err != nil {
		log.Fatalf("failed to call Register method: %v", err)
	}
	bodyBytes, err := ioutil.ReadAll(resp.Body)
	resp.Body.Close()
	if err != nil {
		body = fmt.Sprintf("failed read Login response body: %v", err)
	} else {
		body = string(bodyBytes)
	}
	log.Printf("Loging response: Code=%d, Body=%s\n\n", resp, body)

}
