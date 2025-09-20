package service

import (
	"errors"
	"github-filly/mediact-service/internal/models"
	"github-filly/mediact-service/internal/repository"
)

func CheckLeaveRequest(AssignID int, UserID int, Reason string) error {
	if Reason == "" {
		return errors.New("กรุณากรอกเหตุผลขอลางาน")
	}
	HaveAssignShift, err := repository.FindShiftByID(AssignID)
	if err != nil {
		return err
	}
	if HaveAssignShift == nil {
		return errors.New("ไม่พบมอบหมายงานนี้ในระบบ")
	}

	IsOwnerAssignShift, err := repository.FindAssignShiftByUserIDAndShiftID(HaveAssignShift.ID, UserID)
	if err != nil {
		return err
	}
	if IsOwnerAssignShift == nil {
		return errors.New("คุณไม่ใช่ผู้ได้รับมอบหมายงานนี้")
	}

	println("IsOwnerAssignShift.ID ", IsOwnerAssignShift.ID)
	IsExist, err := repository.FindLeaveRequestByAssignID(IsOwnerAssignShift.ID)
	if err != nil {
		return err
	}
	if IsExist != nil {
		return errors.New("คุณได้ขอลางานในช่วงเวลานี้แล้ว")
	}

	LeaveRequest := models.LeaveRequest{
		Shift_assignment_id: IsOwnerAssignShift.ID,
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
