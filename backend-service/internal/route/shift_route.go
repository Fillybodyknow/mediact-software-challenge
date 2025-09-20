package route

import (
	"github-filly/mediact-service/internal/handle"
	"github-filly/mediact-service/internal/middleware"

	"github.com/gin-gonic/gin"
)

func ShiftRoute(router *gin.Engine) {
	router.Use(middleware.AuthMiddleware())
	router.POST("/shifts", handle.CreateShift)
	router.POST("/shift-assignments", handle.AssignShift)
	router.GET("/my-schedule", handle.NurseSchedule)
}
