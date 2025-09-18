package utils

import (
	"os"
	"time"

	"github.com/golang-jwt/jwt/v5"
)

var jwtSecret = os.Getenv("THE_SECRET_KEY")

func GenarateJWTToken(Id int, Role string) (string, error) {
	claim := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"user_id": Id,
		"role":    Role,
		"exp":     time.Now().Add(time.Hour * 24).Unix(),
		"iat":     time.Now().Unix(),
	})

	signalToken, err := claim.SignedString([]byte(jwtSecret))
	if err != nil {
		return "", err
	}

	return signalToken, nil
}
