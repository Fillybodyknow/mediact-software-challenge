package route

import (
	"github-filly/mediact-service/internal/handle"

	"github.com/gin-gonic/gin"
)

func AuthRoute(router *gin.RouterGroup) {
	router.POST("/register", handle.Register)
	router.POST("/login", handle.Login)
}
