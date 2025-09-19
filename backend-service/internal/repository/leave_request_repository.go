package repository

import (
	"database/sql"
	"github-filly/mediact-service/config"
	"github-filly/mediact-service/internal/models"
)

func FindAllLeaveRequest() ([]models.LeaveRequest, error) {
	rows, err := config.DB.Query("SELECT * FROM leave_requests")
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var leaveRequests []models.LeaveRequest
	for rows.Next() {
		var l models.LeaveRequest
		if err := rows.Scan(&l.ID, &l.Shift_assignment_id, &l.Reason, &l.Status, &l.Approved_id); err != nil {
			return nil, err
		}
		leaveRequests = append(leaveRequests, l)
	}

	return leaveRequests, nil
}

func FindLeaveRequestByAssignID(id int) (*models.LeaveRequest, error) {
	row := config.DB.QueryRow("SELECT * FROM leave_requests WHERE shift_assignment_id = ?", id)

	var l models.LeaveRequest
	err := row.Scan(&l.ID, &l.Shift_assignment_id, &l.Reason, &l.Status, &l.Approved_id)
	if err == sql.ErrNoRows {
		return nil, nil
	} else if err != nil {
		return nil, err
	}

	return &l, nil
}

func FindLeaveRequestByID(id int) (*models.LeaveRequest, error) {
	row := config.DB.QueryRow("SELECT * FROM leave_requests WHERE id = ?", id)

	var l models.LeaveRequest
	err := row.Scan(&l.ID, &l.Shift_assignment_id, &l.Reason, &l.Status, &l.Approved_id)
	if err == sql.ErrNoRows {
		return nil, nil
	} else if err != nil {
		return nil, err
	}

	return &l, nil
}

func InsertLeaveRequest(l models.LeaveRequest) error {
	_, err := config.DB.Exec("INSERT INTO leave_requests (shift_assignment_id, reason, status) VALUES (?, ?, ?)", l.Shift_assignment_id, l.Reason, l.Status)
	if err != nil {
		return err
	}

	return nil
}

func UpdateStatusLeaveRequest(id int, status string, approved_by int) error {
	_, err := config.DB.Exec("UPDATE leave_requests SET status = ?, approved_by = ? WHERE id = ?", status, approved_by, id)
	if err != nil {
		return err
	}

	return nil
}
