package main

import (
	"log"
	"os"

	"github-filly/mediact-service/config"
	"github-filly/mediact-service/internal/route"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

func main() {
	r := gin.Default()
	config.InitDB()

	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}

	Auth := r.Group("/auth")
	{
		route.AuthRoute(Auth)
	}
	route.ShiftRoute(r)
	route.LeaveRequestRoute(r)

	port := os.Getenv("PORT")

	r.Run(":" + port)
}
