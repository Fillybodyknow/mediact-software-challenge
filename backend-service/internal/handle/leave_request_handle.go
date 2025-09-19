package handle

import (
	"github-filly/mediact-service/internal/models"
	"github-filly/mediact-service/internal/repository"
	"github-filly/mediact-service/internal/service"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

func LeaveRequest(c *gin.Context) {
	Role, _ := c.Get("role")
	UserID, _ := c.Get("user_id")

	if Role != "nurse" {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "เฉพาะพยาบาลเท่านั้น"})
		return
	}

	var reason models.LeaveRequestHTTP

	if err := c.ShouldBind(&reason); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := service.CheckLeaveRequest(reason.Shift_assignment_id, int(UserID.(float64)), reason.Reason); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "สร้างข้อมูลเรียบร้อย"})

}

func GetAllLeaveRequest(c *gin.Context) {
	Role, _ := c.Get("role")

	if Role != "head_nurse" {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "เฉพาะหัวหน้าพยาบาลเท่านั้น"})
		return
	}

	LeaveRequests, err := repository.FindAllLeaveRequest()

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"leave_requests": LeaveRequests})
}

func ApproveLeaveRequest(c *gin.Context) {
	Role, _ := c.Get("role")
	UserID, _ := c.Get("user_id")

	if Role != "head_nurse" {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "เฉพาะหัวหน้าพยาบาลเท่านั้น"})
		return
	}

	leaveRequestIDStr := c.Param("id")
	leaveRequestID, err := strconv.Atoi(leaveRequestIDStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "รหัสคำขอลาไม่ถูกต้อง"})
		return
	}

	if err := service.CheckApproveLeaveRequest(leaveRequestID, "approved", int(UserID.(float64))); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "อนุมัติเรียบร้อย"})
}
