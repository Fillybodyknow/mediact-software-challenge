package repository

import (
	"database/sql"
	"github-filly/mediact-service/config"
	"github-filly/mediact-service/internal/models"
	"time"
)

func FindShiftByDate(date string) ([]models.Shift, error) {
	rows, err := config.DB.Query("SELECT id, date, start_time, end_time FROM shifts WHERE date = ?", date)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var shifts []models.Shift

	for rows.Next() {
		var s models.Shift
		var startStr, endStr string
		if err := rows.Scan(&s.ID, &s.Date, &startStr, &endStr); err != nil {
			return nil, err
		}

		startTime, err := time.Parse("15:04:05", startStr)
		if err != nil {
			return nil, err
		}
		endTime, err := time.Parse("15:04:05", endStr)
		if err != nil {
			return nil, err
		}

		s.StartTime = models.TimeOnly(startTime)
		s.EndTime = models.TimeOnly(endTime)

		shifts = append(shifts, s)
	}

	return shifts, nil
}

func FindShiftByID(id int) (*models.Shift, error) {
	row := config.DB.QueryRow("SELECT id, date, start_time, end_time FROM shifts WHERE id = ?", id)

	var s models.Shift
	var startStr, endStr string
	err := row.Scan(&s.ID, &s.Date, &startStr, &endStr)
	if err == sql.ErrNoRows {
		return nil, nil
	} else if err != nil {
		return nil, err
	}

	startTime, err := time.Parse("15:04:05", startStr)
	if err != nil {
		return nil, err
	}
	endTime, err := time.Parse("15:04:05", endStr)
	if err != nil {
		return nil, err
	}

	s.StartTime = models.TimeOnly(startTime)
	s.EndTime = models.TimeOnly(endTime)

	return &s, nil
}

// func FindAssignShiftByShiftID(id int) ([]models.AssignShift, error) {
// 	rows, err := config.DB.Query("SELECT id, user_id, shift_id FROM shift_assignments WHERE shift_id = ?", id)
// 	if err != nil {
// 		return nil, err
// 	}
// 	defer rows.Close()

// 	var assignments []models.AssignShift
// 	for rows.Next() {
// 		var a models.AssignShift
// 		if err := rows.Scan(&a.ID, &a.UserID, &a.ShiftID); err != nil {
// 			return nil, err
// 		}
// 		assignments = append(assignments, a)
// 	}

// 	return assignments, nil
// }

func FindAssignShiftByUserID(id int) ([]models.AssignShift, error) {
	rows, err := config.DB.Query("SELECT id, user_id, shift_id FROM shift_assignments WHERE user_id = ?", id)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var assignments []models.AssignShift
	for rows.Next() {
		var a models.AssignShift
		if err := rows.Scan(&a.ID, &a.UserID, &a.ShiftID); err != nil {
			return nil, err
		}
		assignments = append(assignments, a)
	}

	return assignments, nil
}

func FindAssignShiftByShiftIDAndUserID(id int, userID int) (*models.AssignShift, error) {
	row := config.DB.QueryRow("SELECT * FROM shift_assignments WHERE shift_id = ? AND user_id = ?", id, userID)

	var a models.AssignShift
	err := row.Scan(&a.ID, &a.UserID, &a.ShiftID)
	if err == sql.ErrNoRows {
		return nil, nil
	} else if err != nil {
		return nil, err
	}

	return &a, nil
}

func InsertShift(shift models.Shift) error {
	stmt, err := config.DB.Prepare(`
        INSERT INTO shifts (date, start_time, end_time)
        VALUES (?, ?, ?)
    `)
	if err != nil {
		return err
	}
	defer stmt.Close()

	dateStr := shift.Date.Time().Format("2006-01-02")
	startStr := shift.StartTime.Time().Format("15:04:05")
	endStr := shift.EndTime.Time().Format("15:04:05")

	_, err = stmt.Exec(dateStr, startStr, endStr)
	if err != nil {
		return err
	}

	return nil
}

func InsertAssignShift(shift models.AssignShiftRequest) error {
	stmt, err := config.DB.Prepare(`
		INSERT INTO shift_assignments (shift_id, user_id)
		VALUES (?, ?)
	`)
	if err != nil {
		return err
	}
	defer stmt.Close()

	_, err = stmt.Exec(shift.ShiftID, shift.UserID)
	if err != nil {
		return err
	}

	return nil
}
