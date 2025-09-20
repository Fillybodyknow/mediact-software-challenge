package models

import "database/sql"

type LeaveRequest struct {
	ID                  int           `json:"id"`
	Shift_assignment_id int           `json:"shift_assignment_id"`
	Reason              string        `json:"reason"`
	Status              string        `json:"status"`
	Approved_id         sql.NullInt64 `json:"approved_by"`
}

type LeaveRequestHTTP struct {
	Shift_assignment_id int    `json:"shift_assignment_id" form:"shift_assignment_id"`
	Reason              string `json:"reason" form:"reason"`
}

type LeaveRequestJoinShift struct {
	Reason     string        `json:"reason"`
	Date       string        `json:"date"`
	StartTime  string        `json:"start_time"`
	EndTime    string        `json:"end_time"`
	Status     string        `json:"status"`
	ApprovedBy sql.NullInt64 `json:"approved_by"`
}
