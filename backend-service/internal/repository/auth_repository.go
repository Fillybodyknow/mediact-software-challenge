package repository

import (
	"database/sql"
	"github-filly/mediact-service/config"
	"github-filly/mediact-service/internal/models"
)

func FindUserByEmail(email string) (*models.User, error) {
	row := config.DB.QueryRow("SELECT id, name, email, password, role FROM users WHERE email = ?", email)

	var user models.User
	err := row.Scan(&user.ID, &user.Name, &user.Email, &user.Password, &user.Role)
	if err == sql.ErrNoRows {
		return nil, nil // ไม่มีผู้ใช้
	} else if err != nil {
		return nil, err
	}

	return &user, nil
}

func FindUserByID(id int) (*models.User, error) {
	row := config.DB.QueryRow("SELECT id, name, email, password, role FROM users WHERE id = ?", id)

	var user models.User
	err := row.Scan(&user.ID, &user.Name, &user.Email, &user.Password, &user.Role)
	if err == sql.ErrNoRows {
		return nil, nil // ไม่มีผู้ใช้
	} else if err != nil {
		return nil, err
	}

	return &user, nil
}

func InsertUser(user models.User) error {
	_, err := config.DB.Exec("INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)", user.Name, user.Email, user.Password, user.Role)
	if err != nil {
		return err
	}

	return nil
}
