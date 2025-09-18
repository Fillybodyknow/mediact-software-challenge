package handle

import (
	"fmt"
	"github-filly/mediact-service/internal/models"
	"github-filly/mediact-service/internal/repository"
	"github-filly/mediact-service/internal/service"
	utils "github-filly/mediact-service/utility"
	"net/http"

	"github.com/gin-gonic/gin"
)

func Register(c *gin.Context) {
	var request models.RegisterRequest
	if err := c.ShouldBind(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := service.CheckRegister(request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if _, err := service.CheckEmailIsExist(request.Email); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if ok, _ := service.CheckEmailIsExist(request.Email); ok {
		c.JSON(http.StatusBadRequest, gin.H{"error": "อีเมลนี้ถูกใช้งานแล้ว"})
		return
	}

	HashPass, err := utils.HashPassword(request.Password)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "เกิดข้อผิดพลาดในการสมัครสมาชิก"})
		fmt.Println(err)
		return
	}

	response := models.User{Name: request.Name, Email: request.Email, Password: HashPass, Role: request.Role}

	if err := repository.InsertUser(response); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "เกิดข้อผิดพลาดในการสมัครสมาชิก"})
		fmt.Println(err)
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "สมัครสมาชิกสําเร็จ"})
}

func Login(c *gin.Context) {
	var request models.LoginRequest
	if err := c.ShouldBind(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := service.CheckLogin(request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	token := service.GenarateToken(request.Email)

	c.JSON(http.StatusOK, gin.H{
		"message": "เข้าสู่ระบบสําเร็จ",
		"token":   token,
	})
}
