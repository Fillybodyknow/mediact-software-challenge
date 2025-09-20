package handle

import (
	"github-filly/mediact-service/internal/models"
	"github-filly/mediact-service/internal/service"
	"net/http"

	"github.com/gin-gonic/gin"
)

func CreateShift(c *gin.Context) {
	Role, _ := c.Get("role")

	if Role != "head_nurse" {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "เฉพาะ *หัวหน้าพยาบาล เท่านั้น"})
		return
	}

	var request models.ShiftRequest

	if err := c.ShouldBind(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := service.CheckCreateShift(request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "สร้างข้อมูลเรียบร้อย"})
}

func AssignShift(c *gin.Context) {
	Role, _ := c.Get("role")

	if Role != "head_nurse" {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "เฉพาะ *หัวหน้าพยาบาล เท่านั้น"})
		return
	}

	var request models.AssignShiftRequest

	if err := c.ShouldBind(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := service.CheckAssignShift(request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "สร้างข้อมูลเรียบร้อย"})
}

func NurseSchedule(c *gin.Context) {
	role, _ := c.Get("role")
	userID, _ := c.Get("user_id")

	if role != "nurse" {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "เฉพาะพยาบาลเท่านั้น"})
		return
	}

	uid := int(userID.(float64))

	schedule, err := service.GetNurseSchedule(uid)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"user_id":  uid,
		"role":     role,
		"schedule": schedule,
	})
}
