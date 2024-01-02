import base_url from "../base_url.js";
import elemEvent from "./elemEvent.js";
import confirmationModal from "../modal-method.js";
import fetchApi from "../fetch_method.js";
import toast from "../toast-message.js";

var game_details = null;
var full_details = null;
var elements = null;
const user_id = parseInt(document.querySelector("title").dataset.id);
const urlParams = new URLSearchParams(window.location.search);
var apis = {
	async getEventDetails() {
		return await fetchApi.post(
			`${base_url}/get-event-full-details`,
			"get-event-full-details",
			{
				user_id: user_id,
				oneapp_event_id: parseInt(urlParams.get("oneapp_event_id")),
			},
			true
		);
	},
	async updateAppearance(appearance) {
		return await fetchApi.post(
			`${base_url}/update-event-apperance-state`,
			"update-event-game-appearance-state",
			{
				user_id: user_id,
				event_game_id: parseInt(urlParams.get("event_game_id")),
				appearance_state: appearance.toUpperCase(),
			},
			true
		);
	},
	async updateEventStatus(status) {
		return await fetchApi.post(
			`${base_url}/update-event-game-status`,
			"update-event-game-status",
			{
				user_id: user_id,
				event_game_id: parseInt(urlParams.get("event_game_id")),
				status,
			},
			true
		);
	},
	async declareWinner(market_option_id) {
		return await fetchApi.post(
			`${base_url}/declare-event-game-winner`,
			"declare-event-game-winner",
			{
				user_id: user_id,
				event_game_id: parseInt(urlParams.get("event_game_id")),
				market_option_id,
			},
			true
		);
	},
	async sendPayout(market_option_id) {
		return await fetchApi.post(
			`${base_url}/send-event-game-payouts`,
			"send-event-game-payouts",
			{
				user_id: user_id,
				event_game_id: parseInt(urlParams.get("event_game_id")),
			},
			true
		);
	},
};
const game_status = {
	OPEN: "open-bet",
	"LAST CALL": "last-call",
	CLOSED: "betting-closed",
	CANCELLED: "game-cancelled",
	ENDED: "game-ended",
};

const confirmDisplayUpdate = new confirmationModal(
	".rack-display-confirmation-modal",
	{
		appendClass: {
			title: "text-color--jacarta",
			body: "text-color--jacarta",
		},
	},
	true
);
const updateBettingGameStatus = new confirmationModal(
	".rack-game-status-modal",
	{
		appendClass: {
			title: "text-color--jacarta",
			body: "text-color--jacarta",
		},
	},
	true
);
const cancelRackGame = new confirmationModal(
	".cancel-game-status-modal",
	{
		appendClass: {
			header: "bg-danger",
			title: "text-white",
			body: "text-color--jacarta",
		},
		body: "Are you sure to cancel this rack ?",
	},
	true
);

const statusInfoModal = new confirmationModal(
	".display-information-modal",
	{
		appendClass: {
			body: "text-color--jacarta",
		},
		body: "One of the Market Options already have bet.",
	},
	true
);

const declareWinnerModal = new confirmationModal(
	".declare-winner-modal",
	{},
	true,
	null,
	false
);

const sendPayoutModal = new confirmationModal(
	".send-payout-modal",
	{ body: "You are going to send the payout. Want to proceed ?" },
	true
);

const rackDisplayToggle = new elemEvent(".rack-display-toggle");
const statusBtnController = new elemEvent(".rack-status-controller");
const cancelGameBtn = new elemEvent(".rack-status-controller .btn-cancel-game");
const lastBetBtn = new elemEvent(".rack-status-controller .btn-last-bet");
const closeBetBtn = new elemEvent(".rack-status-controller .btn-close-bet");
const endGameBtn = new elemEvent(".rack-status-controller .btn-end-game");
const declareWinBtn = new elemEvent(".rack-status-controller .btn-declare-win");
const sendPayoutBtn = new elemEvent(".rack-status-controller .btn-send-payout");
const returnPayoutBtn = new elemEvent(
	".rack-status-controller .btn-return-payout"
);

const statusBtnControllerClassList = statusBtnController.getDetails().classList;

window.addEventListener("load", async () => {
	const res = await apis.getEventDetails();

	if (res.status.toUpperCase() == "SUCCESS" && Object.keys(res.data).length) {
		full_details = res.data;
	} else {
		return;
	}

	game_details = full_details.event_games_details.find(
		(game) => game.id == parseInt(urlParams.get("event_game_id"))
	);

	const { market_options_details } = game_details;

	console.log(declareWinnerModal.modal);

	elements = {
		mainContainer: new elemEvent(".rack-controller"),
		declare_winner: {
			modal: declareWinnerModal.modal,
			updateInfo: (side) => {
				const elem =
					declareWinnerModal.modal.querySelector(".modal-footer span");
				const player = market_options_details.find(
					(opt) => opt.market_option_position == side
				);

				elem.classList.remove("text-right-player", "text-left-player");
				elem.classList.add(
					`text-${[player.market_option_position.toLowerCase()]}-player`
				);

				elem.innerHTML = player.market_option_short_name;
			},
			player_left: {
				name: declareWinnerModal.modal.querySelector(
					".player-card.left .player-name"
				),
				team: declareWinnerModal.modal.querySelector(
					".player-card.left .player-team"
				),
				seq: declareWinnerModal.modal.querySelector(".player-card.left .seq"),
				score: declareWinnerModal.modal.querySelector(
					".player-card.left .score"
				),
				ranking: declareWinnerModal.modal.querySelector(
					".player-card.left .ranking"
				),
				img: declareWinnerModal.modal.querySelector(
					".player-card.left #PlayerImg"
				),
			},
			player_right: {
				name: declareWinnerModal.modal.querySelector(
					".player-card.right .player-name"
				),
				team: declareWinnerModal.modal.querySelector(
					".player-card.right .player-team"
				),
				seq: declareWinnerModal.modal.querySelector(".player-card.right .seq"),
				score: declareWinnerModal.modal.querySelector(
					".player-card.right .score"
				),
				ranking: declareWinnerModal.modal.querySelector(
					".player-card.right .ranking"
				),
				img: declareWinnerModal.modal.querySelector(
					".player-card.right #PlayerImg"
				),
			},
		},
		game_title: new elemEvent(".per-rack-title"),
		game_status: new elemEvent(".rack-status-controller"),
		video_stream: new elemEvent(".live-stream iframe"),
		gross_amt: new elemEvent(".game-pool .pool"),
		pool_vigorish: new elemEvent(".game-pool .pool-vigorish"),
		net_pool: new elemEvent(".game-pool .net-pool"),

		player_left: {
			details: new elemEvent(".player-score-board.left-player .player-sq-name"),
			wins: new elemEvent(".player-score-board.left-player .win-count"),
			gross_amt: new elemEvent(".player-score-board.left-player .gross-amount"),
			odd: new elemEvent(".player-score-board.left-player .odds"),
			vigorish: new elemEvent(".player-score-board.left-player .vigorish"),
			net_amt: new elemEvent(".player-score-board.left-player .net-amount"),
			score: new elemEvent(".player-score-board.left-player .player-score"),
		},

		player_right: {
			details: new elemEvent(
				".player-score-board.right-player .player-sq-name"
			),
			wins: new elemEvent(".player-score-board.right-player .win-count"),
			gross_amt: new elemEvent(
				".player-score-board.right-player .gross-amount"
			),
			odd: new elemEvent(".player-score-board.right-player .odds"),
			vigorish: new elemEvent(".player-score-board.right-player .vigorish"),
			net_amt: new elemEvent(".player-score-board.right-player .net-amount"),
			score: new elemEvent(".player-score-board.right-player .player-score"),
		},
		updateMarketOptionsDetails(options, bet_details_only = false) {
			options.forEach((data) => {
				const side = data.market_option_position.toLowerCase();
				if (!bet_details_only) {
					this[`player_${side}`].details.updateInnerText(
						this[`player_${side}`].details
							.getInnerText()
							.replace("{sq}", data.market_option_sequence)
							.replace("{name}", data.market_option_short_name)
					);
					this[`player_${side}`].wins.updateInnerText(
						this[`player_${side}`].wins
							.getInnerText()
							.replace("{win}", data.market_option_wins ?? "0")
					);

					const { seq, name, team, score, ranking, img } =
						this.declare_winner[`player_${side}`];
					seq.innerHTML = data.market_option_sequence;
					name.innerHTML = data.market_option_short_name;
					team.innerHTML = data.market_option_team_name.length
						? data.market_option_team_name
						: "-";
					score.innerHTML = data.market_option_score;

					if (data.market_option_team_logo_url)
						img.src = data.market_option_team_logo_url;
				}
				this[`player_${side}`].odd.updateInnerText(
					`${parseFloat(data.market_option_payout_odds).toFixed(2)}`
				);
				this[`player_${side}`].gross_amt.updateInnerText(
					`P ${parseFloat(data.total_bet_amount).toFixed(2)}`
				);
				this[`player_${side}`].vigorish.updateInnerText(
					`P ${parseFloat(data.vigorished_total_bet_amount).toFixed(2)}`
				);
				this[`player_${side}`].net_amt.updateInnerText(
					`P ${parseFloat(data.market_option_payout_odds).toFixed(2)}`
				);
				this[`player_${side}`].score.updateInnerText(
					data.market_option_score.length == 1
						? `0${data.market_option_score}`
						: data.market_option_score
				);
			});

			this.gross_amt.updateInnerText(parseFloat(0).toFixed(2));
			this.pool_vigorish.updateInnerText(
				parseFloat(game_details.event_game_vigorish_percent).toFixed(2)
			);
			this.net_pool.updateInnerText(parseFloat(0).toFixed(2));
		},
		poolingMarketOptionDetails() {
			if (
				!["open-bet", "last-call"].includes(
					this.game_status.element.classList[4]
				)
			)
				return;

			setTimeout(async () => {
				await this.setMarketOptionUpdate();
				await this.poolingMarketOptionDetails();
			}, 1000);
		},
		async setMarketOptionUpdate(exec_multiplyer = 1) {
			const res = await apis.getEventDetails();

			for (let i = 0; i < exec_multiplyer; i++)
				if (res.status == "success" && res.status_code == 200) {
					this.updateMarketOptionsDetails(
						res.data?.event_games_details.find(
							(game) => game.id == parseInt(urlParams.get("event_game_id"))
						).market_options_details,
						true
					);
					return;
				}
		},
	};

	if (game_details.appearance_state == "DISPLAYED")
		document.querySelector("#toggle-display").checked = true;

	if (game_details.appearance_state == "DISPLAYED")
		document.querySelector("#toggle-display").checked = true;

	elements.mainContainer
		.getDetails()
		.classList.add(
			game_details.appearance_state == "HIDDEN"
				? "status-hidden"
				: "status-displayed"
		);

	elements.game_title.updateInnerText(
		elements.game_title
			.getInnerText()
			.replace("{title}", game_details.event_game_description)
	);

	if (
		!document.querySelector("iframe").src.includes("&autoplay=1&mute=1") &&
		!document.querySelector("iframe").src.includes("&mute=1&autoplay=1")
	)
		document
			.querySelector("iframe")
			.setAttribute(
				"src",
				`${document
					.querySelector("iframe")
					.getAttribute("src")}&autoplay=1&mute=1`
			);

	if (
		game_details.winner_announcement_details &&
		!Array.isArray(game_details.winner_announcement_details)
	) {
		const winner = market_options_details.find(
			(opt) =>
				opt.id == game_details.winner_announcement_details.market_option_id
		);
		elements.game_status.replaceClass(4, "winner-declared");
		elements.mainContainer.element.classList.add(
			`game-winner-${winner.market_option_position.toLowerCase()}`
		);
	} else if (game_details.status != "OPEN")
		elements.game_status.replaceClass(4, game_status[game_details.status]);

	// elements.gross_amt.updateInnerText(parseFloat(0).toFixed(2));
	// elements.pool_vigorish.updateInnerText(
	// 	parseFloat(game_details.event_game_vigorish_percent).toFixed(2)
	// );
	// elements.net_pool.updateInnerText(parseFloat(0).toFixed(2));

	elements.updateMarketOptionsDetails(market_options_details);
	// market_options_details.forEach((opt) => {
	// 	let option = document.createElement("option");
	// 	option.classList.add(
	// 		`text-${opt.market_option_position.toLowerCase()}-player`,
	// 		"text-capitalize"
	// 	);
	// 	option.text = `${opt.market_option_position.toLowerCase()} - ${
	// 		opt.market_option_name
	// 	}`;
	// 	option.value = `${opt.id}-${opt.market_option_position.toLowerCase()}`;
	// 	option.classList.add(opt.market_option_position.toLowerCase());
	// 	elements.declare_winner_option.getDetails().add(option);
	// });

	// elements.declare_winner_option
	// 	.getDetails()
	// 	.addEventListener("change", function (e) {
	// 		if (!this.value) {
	// 			this.removeAttribute("right-selected");
	// 			this.removeAttribute("left-selected");
	// 			return;
	// 		}
	// 		if (this.value.includes("left")) {
	// 			this.removeAttribute("right-selected");
	// 			this.setAttribute("left-selected", "");
	// 			return;
	// 		}
	// 		this.removeAttribute("left-selected");
	// 		this.setAttribute("right-selected", "");
	// 	});

	// const { modal, left_side, right_side } = elements.declare_winner;

	elements.declare_winner.modal
		.querySelector(".player-card.left")
		.addEventListener("click", function () {
			elements.declare_winner.modal.querySelector(
				".modal-footer"
			).style.display = "flex";
			elements.declare_winner.updateInfo("LEFT");
			elements.declare_winner.modal.classList.add("left-selected");
		});
	elements.declare_winner.modal
		.querySelector(".player-card.right")
		.addEventListener("click", function () {
			elements.declare_winner.modal.querySelector(
				".modal-footer"
			).style.display = "flex";
			elements.declare_winner.updateInfo("RIGHT");
			elements.declare_winner.modal.classList.add("right-selected");
		});

	document
		.querySelectorAll(".placeholder")
		.forEach((el) =>
			el.classList.remove("placeholder", "text-primary", "text-danger")
		);

	elements.poolingMarketOptionDetails();
});

cancelGameBtn.click(() => {
	cancelRackGame.show();
});
lastBetBtn.click(() => {
	updateBettingGameStatus.updateDetails(
		null,
		"Are you sure to declare last call ?"
	);
	updateBettingGameStatus.show();
});
closeBetBtn.click(() => {
	updateBettingGameStatus.updateDetails(
		null,
		"Are you sure to declare close bet ?"
	);
	updateBettingGameStatus.show();
});
endGameBtn.click(() => {
	updateBettingGameStatus.updateDetails(
		null,
		"Are you sure to end the game ?",
		{ header: "bg-primary", btn_right: "bg-primary" }
	);
	updateBettingGameStatus.show();
});

declareWinBtn.click(() => {
	declareWinnerModal.show();
	// statusBtnControllerClassList.replace(
	// 	statusBtnControllerClassList[4],
	// 	"winner-declared"
	// );
});

sendPayoutBtn.click(() => {
	sendPayoutModal.show();
});

returnPayoutBtn.click(() => {
	statusBtnControllerClassList.replace(
		statusBtnControllerClassList[4],
		"payout-returned"
	);
});

rackDisplayToggle.click((e) => {
	e.preventDefault();
	const { market_options_details } = game_details;

	if (
		game_details.appearance_state == "DISPLAYED" &&
		(parseFloat(market_options_details[0].total_bet_amount) ||
			parseFloat(market_options_details[1].total_bet_amount))
	) {
		statusInfoModal.show();
		return;
	}

	confirmDisplayUpdate.updateDetails(
		null,
		`Are you sure to update the rack appearance to ${
			game_details.appearance_state == "HIDDEN" ? "display" : "hidden"
		} ?`
	);
	confirmDisplayUpdate.show();
});

confirmDisplayUpdate.rBtnClick(async function (e, modal) {
	e.preventDefault();
	e.stopPropagation();

	const new_appearance =
		game_details.appearance_state == "HIDDEN" ? "DISPLAYED" : "HIDDEN";

	const { market_options_details } = game_details;

	confirmDisplayUpdate.loading(true);

	try {
		const res = await apis.updateAppearance(new_appearance);

		if (res.status_code >= 400 && res.status == "failed") {
			throw res;
		}
		game_details.appearance_state = new_appearance;
		toast({
			title: "Success",
			message: res.description,
			type: "success",
			duration: 5000,
		});
		document.querySelector("#toggle-display").checked =
			!document.querySelector("#toggle-display").checked;
		modal.hide();
		return;
	} catch (e) {
		toast({
			title: "An error occured",
			message: e.description,
			type: "error",
			duration: 5000,
		});
	}
	confirmDisplayUpdate.loading(false);
});

updateBettingGameStatus.rBtnClick(async function (e, modal) {
	e.preventDefault();
	e.stopPropagation();

	modal.loading(true);

	const status = elements.game_status.getDetails().classList[4];

	const statuses = {
		"open-bet": async () => {
			try {
				const res = await apis.updateEventStatus("LAST CALL");

				if (res.status != "success" && res.status_code >= 300) throw res;

				toast({
					title: "Update Successful",
					message: e.description,
					type: "success",
					duration: 5000,
				});
				statusBtnControllerClassList.replace(
					statusBtnControllerClassList[4],
					"last-call"
				);
				updateBettingGameStatus.hide();
			} catch (e) {
				toast({
					title: "An error occured",
					message: e.description,
					type: "error",
					duration: 5000,
				});
			}
		},
		"last-call": async () => {
			try {
				const res = await apis.updateEventStatus("CLOSED");

				if (res.status != "success" && res.status_code >= 300) throw res;

				toast({
					title: "Update Successful",
					message: e.description,
					type: "success",
					duration: 5000,
				});
				statusBtnControllerClassList.replace(
					statusBtnControllerClassList[4],
					"betting-closed"
				);
				await elements.setMarketOptionUpdate(3);
				updateBettingGameStatus.hide();
			} catch (e) {
				console.log(e);
				toast({
					title: "An error occured",
					message: e.description,
					type: "error",
					duration: 5000,
				});
			}
		},
		"betting-closed": async () => {
			try {
				const res = await apis.updateEventStatus("ENDED");

				if (res.status != "success" && res.status_code >= 300) throw res;

				toast({
					title: "Update Successful",
					message: e.description,
					type: "success",
					duration: 5000,
				});
				statusBtnControllerClassList.replace(
					statusBtnControllerClassList[4],
					"game-ended"
				);
				updateBettingGameStatus.hide();
			} catch (e) {
				toast({
					title: "An error occured",
					message: e.description,
					type: "error",
					duration: 5000,
				});
			}
		},
		"game-ended": async () => {
			try {
				statusBtnControllerClassList.replace(
					statusBtnControllerClassList[4],
					"winner-declared"
				);
				updateBettingGameStatus.hide();
			} catch (e) {}
		},
		"winner-declared": async () => {
			try {
				statusBtnControllerClassList.replace(
					statusBtnControllerClassList[4],
					"send-payout"
				);
				updateBettingGameStatus.hide();
			} catch (e) {}
		},
		"game-cancelled": () => {},
		"winner-declared": () => {
			//
		},
	};

	await statuses[status]();

	modal.loading(false);
});

cancelRackGame.rBtnClick(async function (e, modal) {
	const btnR = modal.btns[1];
	const btnL = modal.btns[0];
	btnR.innerHTML = btnR.innerHTML.replace("Confirm", `Proceed`);
	btnR.classList.replace("bg-primary", "bg-danger");
	btnL.classList.replace("bg-danger", "bg-secondary");
});

declareWinnerModal.lBtnClick(async function () {
	elements.declare_winner.modal.classList.remove(
		"left-selected",
		"right-selected"
	);
	elements.declare_winner.modal.querySelector(".modal-footer").style.display =
		"none";
});

declareWinnerModal.rBtnClick(async function (e, modal) {
	const declareModal = elements.declare_winner.modal;
	const { market_options_details } = game_details;

	modal.loading(true);
	if (
		!declareModal.classList.contains("left-selected") &&
		!declareModal.classList.contains("right-selected")
	) {
		toast({
			title: "Non-selected",
			message: "None of market options are selected.",
			type: "error",
			duration: 5000,
		});
		modal.loading(false);
		return;
	}

	const winner = market_options_details.filter(
		(opt) =>
			opt.market_option_position ==
			declareModal.classList[4].split("-")[0].toUpperCase()
	)[0];

	try {
		const res = await apis.declareWinner(parseInt(winner.id));
		if (res.status == "failed" || res.status_code >= 300) throw res;

		statusBtnControllerClassList.replace(
			statusBtnControllerClassList[4],
			"winner-declared"
		);

		toast({
			title: "Declaration Success",
			message: `You declare ${
				market_options_details.find((opt) => opt.id == parseInt(winner.id))
					.market_option_short_name
			} as rack winner.`,
			type: "success",
			duration: 5000,
		});
		modal.hide();
	} catch (e) {
		toast({
			title: "An error occured",
			message: "Please try again to declare.",
			type: "error",
			duration: 5000,
		});
		modal.loading(false);
	}
});

sendPayoutModal.rBtnClick(async function (e, modal) {
	modal.loading(true);

	const res = await apis.sendPayout();

	if (
		Object.keys(res).includes("error") ||
		res.status == "failed" ||
		res.status_code >= 300
	) {
		toast({
			title: "Sending Failed",
			message: `An error occur on sending payouts.`,
			type: "failed",
			duration: 5000,
		});
		modal.loading(false);
		return;
	}
	toast({
		title: "Payouts Sent",
		message: `Payouts successfuly sent to the winners.`,
		type: "success",
		duration: 5000,
	});
	modal.hide();
});
