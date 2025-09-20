package service

import (
	"errors"
	"github-filly/mediact-service/internal/models"
	"github-filly/mediact-service/internal/repository"
	utils "github-filly/mediact-service/utility"
)

func CheckRegister(request models.RegisterRequest) error {
	if request.Name == "" {
		return errors.New("กรุณากรอกชื่อ")
	}

	if request.Email == "" {
		return errors.New("กรุณากรอกอีเมล")
	}

	if request.Password == "" {
		return errors.New("กรุณากรอกรหัสผ่าน")
	}

	if request.VerifyPassword == "" {
		return errors.New("กรุณายืนยันรหัสผ่าน")
	}

	if request.Password != request.VerifyPassword {
		return errors.New("รหัสผ่านและยืนยันรหัสผ่านไม่ตรงกัน")
	}

	return nil
}

func CheckEmailIsExist(email string) (bool, error) {
	users, err := repository.FindUserByEmail(email)
	if err != nil {
		return false, err
	}

	if users == nil {
		return false, nil
	}

	return true, nil
}

func CheckLogin(request models.LoginRequest) error {
	if request.Email == "" {
		return errors.New("กรุณากรอกอีเมล")
	}

	if request.Password == "" {
		return errors.New("กรุณากรอกรหัสผ่าน")
	}

	user, err := repository.FindUserByEmail(request.Email)
	if err != nil {
		return err
	}

	if user == nil {
		return errors.New("ไม่พบอีเมลนี้ในระบบ")
	}

	if !utils.CheckPasswordHash(request.Password, user.Password) {
		return errors.New("รหัสผ่านไม่ถูกต้อง")
	}

	return nil
}

func GenarateToken(email string) string {
	user, _ := repository.FindUserByEmail(email)
	token, _ := utils.GenerateJWTToken(user.ID, user.Role)
	return token
}
