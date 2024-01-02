import elEvent from "./declarator/elemEvent.js";
import fetchMethod from "./fetch_method.js";
import base_url from "./base_url.js";

const formElem = new elEvent("form.login-form");
const unameInput = new elEvent("input[type=text]");
const passInput = new elEvent("input[type=password]");
const errorMessage = new elEvent(".error-message");
const submitContainer = new elEvent(".submit-container");

unameInput.change(function () {
	this.classList.remove("no-value");
	hideErrMsg();
});

passInput.change(function () {
	this.classList.remove("no-value");
	hideErrMsg();
});

formElem.submit(validateInput);

async function validateInput(evt) {
	evt.preventDefault();
	const uname = formElem.element[0].value;
	const pword = formElem.element[1].value;
	if (!uname) formElem.element[0].classList.add("no-value");
	if (!pword) formElem.element[1].classList.add("no-value");

	if (!uname || !pword) return;

	await authenticate(uname, pword);
}

async function authenticate(mobile_number, password) {
	const errMsgEl = errorMessage.getDetails();
	const submitCont = submitContainer.getDetails();

	submitCont.classList.add("loading");
	hideErrMsg();

	try {
		
		const res = await fetchMethod.post(`${base_url}/login_authentication`, "login", {
			
			mobile_number,
			password,
		});
		

		if (res.status == 'success') {
            showErrMsg(res.description, "bg-success");

			setTimeout(
				() => window.location.replace(res.redirect_url),
				1000
			);
			return;
		}

		if (res && res.status_code == 400) {
            submitCont.classList.remove("loading");
			showErrMsg(res.description);
		}
	} catch (e) {
		console.log(e);
		submitCont.classList.remove("loading");
		showErrMsg("An error occured");
	}
}

function hideErrMsg() {
	errorMessage.getDetails().classList.remove("show");
	errorMessage.getDetails().innerHTML = "Incorrect username or password";
}

function showErrMsg(message, _class = "") {
	errorMessage.getDetails().classList.add(`show`);
	if (_class) errorMessage.getDetails().classList.add(_class);
	errorMessage.getDetails().innerHTML =
		message ?? "Incorrect username or password";
}
