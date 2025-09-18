package models

import (
	"fmt"
	"time"
)

type DateOnly time.Time

func (d *DateOnly) UnmarshalJSON(b []byte) error {
	s := string(b)
	if len(s) < 2 {
		return nil
	}
	s = s[1 : len(s)-1] // ตัด " ออก
	t, err := time.Parse("2006-01-02", s)
	if err != nil {
		return err
	}
	*d = DateOnly(t)
	return nil
}

func (d DateOnly) MarshalJSON() ([]byte, error) {
	str := fmt.Sprintf("\"%s\"", time.Time(d).Format("2006-01-02"))
	return []byte(str), nil
}

func (d DateOnly) Time() time.Time {
	return time.Time(d)
}

type TimeOnly time.Time

func (t *TimeOnly) UnmarshalJSON(b []byte) error {
	s := string(b)
	if len(s) < 2 {
		return nil
	}
	s = s[1 : len(s)-1]
	parsed, err := time.Parse("15:04:05", s)
	if err != nil {
		return err
	}
	*t = TimeOnly(parsed)
	return nil
}

func (t TimeOnly) MarshalJSON() ([]byte, error) {
	str := fmt.Sprintf("\"%s\"", time.Time(t).Format("15:04:05"))
	return []byte(str), nil
}

func (t TimeOnly) Time() time.Time {
	return time.Time(t)
}

type ShiftRequest struct {
	Date      DateOnly `json:"date"`
	StartTime TimeOnly `json:"start_time"`
	EndTime   TimeOnly `json:"end_time"`
}

type Shift struct {
	ID        int      `json:"id" form:"id"`
	Date      DateOnly `json:"date" form:"date"`
	StartTime TimeOnly `json:"start_time" form:"start_time"`
	EndTime   TimeOnly `json:"end_time" form:"end_time"`
}

type AssignShiftRequest struct {
	ShiftID int `json:"shift_id" form:"shift_id"`
	UserID  int `json:"user_id" form:"user_id"`
}

type AssignShift struct {
	ID      int `json:"id" form:"id"`
	ShiftID int `json:"shift_id" form:"shift_id"`
	UserID  int `json:"user_id" form:"user_id"`
}
