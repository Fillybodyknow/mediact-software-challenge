package main

import (
	"log"
	"os"

	"github-filly/mediact-service/config"
	"github-filly/mediact-service/internal/route"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

func main() {
	r := gin.Default()
	r.Use(cors.New(cors.Config{
		AllowOrigins:     []string{"http://localhost:3000", "http://101.51.39.123:3000"},
		AllowMethods:     []string{"GET", "POST", "PUT", "DELETE"},
		AllowHeaders:     []string{"Authorization", "Content-Type"},
		AllowCredentials: true,
	}))
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
