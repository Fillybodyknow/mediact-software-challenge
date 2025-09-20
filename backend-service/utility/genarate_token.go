package utils

import (
	"errors"
	"os"
	"time"

	"github.com/golang-jwt/jwt/v5"
)

func GenerateJWTToken(Id int, Role string) (string, error) {
	jwtSecret := os.Getenv("THE_SECRET_KEY") // โหลดตอนเรียกใช้
	if jwtSecret == "" {
		return "", errors.New("THE_SECRET_KEY ไม่ถูกตั้งค่า")
	}

	claims := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"user_id": Id,
		"role":    Role,
		"exp":     time.Now().Add(time.Hour * 24).Unix(),
		"iat":     time.Now().Unix(),
	})

	tokenString, err := claims.SignedString([]byte(jwtSecret))
	if err != nil {
		return "", err
	}

	return tokenString, nil
}
