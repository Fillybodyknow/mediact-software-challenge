package service

import (
	"errors"
	"github-filly/mediact-service/internal/models"
	"github-filly/mediact-service/internal/repository"
)

func CheckLeaveRequest(AssignID int, UserID int, Reason string) error {
	HaveAssignShift, err := repository.FindAssignShiftByID(AssignID)
	if err != nil {
		return err
	}
	if HaveAssignShift == nil {
		return errors.New("ไม่พบมอบหมายงานนี้ในระบบ")
	}
	IsOwnerAssignShift, err := repository.FindAssignShiftByUserIDAndAssignID(AssignID, UserID)
	if err != nil {
		return err
	}
	if IsOwnerAssignShift == nil {
		return errors.New("คุณไม่ใช่ผู้ได้รับมอบหมายงานนี้")
	}
	IsExist, err := repository.FindLeaveRequestByAssignID(AssignID)
	if err != nil {
		return err
	}
	if IsExist != nil {
		return errors.New("คุณได้ขอลางานในช่วงเวลานี้แล้ว")
	}

	LeaveRequest := models.LeaveRequest{
		Shift_assignment_id: AssignID,
		Reason:              Reason,
		Status:              "pending",
	}

	if err := repository.InsertLeaveRequest(LeaveRequest); err != nil {
		return err
	}

	return nil
}

func CheckApproveLeaveRequest(LeaveRequestID int, Status string, ApprovedBy int) error {
	LeaveRequest, err := repository.FindLeaveRequestByID(LeaveRequestID)
	if err != nil {
		return err
	}
	if LeaveRequest == nil {
		return errors.New("ไม่พบข้อมูลขอลางาน")
	}

	if LeaveRequest.Approved_id.Valid {
		return errors.New("ข้อมูลขอลางานนี้ได้รับการอนุมัติแล้ว")
	}

	if err := repository.UpdateStatusLeaveRequest(LeaveRequestID, Status, ApprovedBy); err != nil {
		return err
	}

	return nil
}
