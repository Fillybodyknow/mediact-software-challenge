package service

import (
	"errors"
	"github-filly/mediact-service/internal/models"
	"github-filly/mediact-service/internal/repository"
	"time"
)

func CheckCreateShift(input models.ShiftRequest) error {
	if time.Time(input.Date).IsZero() || time.Time(input.StartTime).IsZero() || time.Time(input.EndTime).IsZero() {
		return errors.New("กรุณากรอกข้อมูลให้ครบถ้วน")
	}

	if err := CheckTimePeriod(input); err != nil {
		return err
	}

	shift := models.Shift{
		Date:      input.Date,
		StartTime: input.StartTime,
		EndTime:   input.EndTime,
	}

	if err := repository.InsertShift(shift); err != nil {
		return err
	}

	return nil
}

func CheckTimePeriod(input models.ShiftRequest) error {
	shifts, err := repository.FindShiftByDate(time.Time(input.Date).Format("2006-01-02"))
	if err != nil {
		return err
	}

	for _, timePeriod := range shifts {
		if time.Time(input.StartTime).Before(time.Time(timePeriod.EndTime)) && time.Time(input.EndTime).After(time.Time(timePeriod.StartTime)) {
			return errors.New("ช่วงเวลาที่กรอกทับซ้อนกับช่วงเวลาอื่นในวันเดียวกัน")
		}
	}

	return nil
}

func CheckAssignShift(request models.AssignShiftRequest) error {
	if request.ShiftID == 0 {
		return errors.New("กรุณาเลือกช่วงเวลา")
	}

	if request.UserID == 0 {
		return errors.New("กรุณาเลือกแพทย์")
	}

	shift, err := repository.FindShiftByID(request.ShiftID)
	if err != nil {
		return err // DB error
	}
	if shift == nil {
		return errors.New("ไม่พบช่วงเวลานี้ในระบบ")
	}

	assignments, err := repository.FindAssignShiftByShiftID(request.ShiftID)
	if err != nil {
		return err
	}
	if len(assignments) > 0 {
		return errors.New("มีพยาบาลอื่นได้รับช่วงเวลานี้แล้ว")
	}

	if nurse, _ := repository.FindUserByID(request.UserID); nurse == nil || nurse.Role != "nurse" {
		return errors.New("ไม่พบพยาบาลคนนี้ในระบบ")
	}

	if err := repository.InsertAssignShift(request); err != nil {
		return err
	}

	return nil
}

func GetNurseSchedule(user_id int) ([]models.Shift, error) {

	var assignmentsDetail []models.Shift

	nurse, err := repository.FindUserByID(user_id)
	if err != nil {
		return nil, err
	}

	if nurse == nil || nurse.Role != "nurse" {
		return nil, errors.New("ไม่พบพยาบาลคนนี้ในระบบ")
	}
	assignments, err := repository.FindAssignShiftByUserID(user_id)
	if err != nil {
		return nil, err
	}

	for _, a := range assignments {
		shift, err := repository.FindShiftByID(a.ShiftID)
		if err != nil {
			return nil, err
		}
		assignmentsDetail = append(assignmentsDetail, *shift)
	}

	return assignmentsDetail, nil
}
