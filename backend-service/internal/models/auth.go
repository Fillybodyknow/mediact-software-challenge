package models

type RegisterRequest struct {
	Name           string `json:"name" form:"name"`
	Email          string `json:"email" form:"email" binding:"required,email"`
	Role           string `json:"role" form:"role"`
	Password       string `json:"password" form:"password"`
	VerifyPassword string `json:"verify_password" form:"verify_password"`
}

type LoginRequest struct {
	Email    string `json:"email" form:"email"`
	Password string `json:"password" form:"password"`
}

type User struct {
	ID       int    `json:"id"`
	Name     string `json:"name"`
	Email    string `json:"email"`
	Password string `json:"password"`
	Role     string `json:"role"`
}
