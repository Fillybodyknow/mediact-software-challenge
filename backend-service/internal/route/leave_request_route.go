package route

import (
	"github-filly/mediact-service/internal/handle"
	"github-filly/mediact-service/internal/middleware"

	"github.com/gin-gonic/gin"
)

func LeaveRequestRoute(router *gin.Engine) {
	router.Use(middleware.AuthMiddleware())
	router.POST("/leave-requests", handle.LeaveRequest)
	router.GET("/leave-requests", handle.GetAllLeaveRequest)
	router.PATCH("/leave-requests/:id/approve", handle.ApproveLeaveRequest)
}
