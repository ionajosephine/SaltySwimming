import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["picker", "select"];

  connect() {
    if (this.hasPickerTarget) {
      this.initializePicker();
    }
  }

  initializePicker() {
    this.picker = flatpickr(this.pickerTarget, {
      defaultDate: "today",
      altInput: true,
      altFormat: "F j, Y",
      onClose: (_, __, selectedDate) => {
        if (selectedDate) {
          this.selectTarget.value = selectedDate;
        }
      },
    });
  }

  selectDate(event) {
    const date = event.target.dataset.date;

    if (date === "today") {
      this.selectTarget.value = new Date().toISOString().split("T")[0];
    } else if (date === "yesterday") {
      const yesterday = new Date();
      yesterday.setDate(yesterday.getDate() - 1);
      this.selectTarget.value = yesterday.toISOString().split("T")[0];
    } else if (date === "select-date") {
      this.picker.open();
    }
  }
}
