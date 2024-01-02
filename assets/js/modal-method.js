export default class {
	constructor(
		uniqueIdentifier,
		modal_details,
		persistent = false,
		event = null,
		closeModalOnCancel = true
	) {
		const { title, body, appendClass } = modal_details;
		this.modalIdentifier = {};

		this.modal = document.querySelector(uniqueIdentifier);
		this.header = this.modal.querySelector(".modal-header");
		this.title = this.modal.querySelector(".modal-title");
		this.body = this.modal.querySelector(".modal-body p");
		this.btns = this.modal.querySelectorAll("button");

		if (typeof modal_details == "object" && modal_details != null)
			this.updateDetails(title, body, appendClass);

		this.modal.onclick = (e) => {
			e.preventDefault();
			if (
				e.target.classList.contains(uniqueIdentifier.replace(/[.#]/g, "")) &&
				!persistent
			)
				this.hide();
		};

		if (closeModalOnCancel) {
			this.btns[0].addEventListener("click", () => {
				this.hide();
			});
		}

		if (event && typeof event == "function") {
			event();
		}
	}

	updateDetails(
		title = null,
		body = null,
		appendClass = {
			title: null,
			body: null,
			header: null,
			btn_left: null,
			btn_right: null,
		}
	) {
		if (title) this.title.innerHTML = title;
		if (body) this.body.innerHTML = body;

		if (appendClass.title)
			if (Array.isArray(appendClass.title))
				appendClass.title.forEach((_class) => this.title.classList.add(_class));
			else if (typeof appendClass.title == "string")
				this.title.classList.value = this.title.classList.value.concat(
					` ${appendClass.title}`
				);

		if (appendClass.body)
			if (Array.isArray(appendClass.body))
				appendClass.body.forEach((_class) => this.body.classList.add(_class));
			else if (typeof appendClass.body == "string")
				this.body.classList.value = this.body.classList.value.concat(
					` ${appendClass.body}`
				);

		if (appendClass.header)
			if (Array.isArray(appendClass.header))
				appendClass.header.forEach((_class) =>
					this.header.classList.add(_class)
				);
			else if (typeof appendClass.header == "string")
				this.header.classList.value = this.header.classList.value.concat(
					` ${appendClass.header}`
				);

		if (appendClass.btn_left)
			if (Array.isArray(appendClass.btn_left))
				appendClass.btn_left.forEach((_class) =>
					this.btns[0].classList.add(_class)
				);
			else if (typeof appendClass.btn_left == "string")
				this.btns[0].classList.value = this.btns[0].classList.value.concat(
					` ${appendClass.btn_left}`
				);

		if (appendClass.btn_right)
			if (Array.isArray(appendClass.btn_right))
				appendClass.btn_right.forEach((_class) =>
					this.btns[1].classList.add(_class)
				);
			else if (typeof appendClass.btn_right == "string")
				this.btns[1].classList.value = this.btns[1].classList.value.concat(
					` ${appendClass.btn_right}`
				);
	}

	async loading(state) {
		// if (typeof state != "boolean")
		// 	throw "State propert should be a boolean data type.";
		// if (typeof trigger == "function") {
		// 	await e();
		// 	return;
		// }
		this.btns.forEach((btn) => {
			btn.classList[state ? "add" : "remove"]("placeholder");
		});
	}

	show() {
		this.modal.style.display = "block";
		setTimeout(() => this.modal.classList.add("show"), 100);
	}

	hide() {
		this.modal.classList.remove("show");
		setTimeout(() => {
			this.modal.style.display = "none";
			this.btns.forEach((btn) => {
				btn.classList.remove("placeholder");
			});
		}, 100);
	}

	rBtnClick(evt) {
		this.btns[1].addEventListener("click", async (e) => {
			await evt(e, this);
		});
	}

	lBtnClick(evt) {
		this.btns[0].addEventListener("click", async (e) => {
			await evt(e);
		});
	}
}
