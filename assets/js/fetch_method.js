export default {
	statusCode: {
		200: "OK",
		201: "Created",
		204: "No Content",
		303: "See Other",
		307: "Temporary Redirect",
		400: "Bad Request",
		401: "Unauthorized",
		402: "Payment Required",
		403: "Forbidden",
		404: "Not Found",
		408: "Request Timeout",
		429: "Too Many Requests",
		500: "Internal Server Error",
		502: "Bad Gateway",
		504: "Gateway Timeout",
	},
	async get(subDir, endpoint, data = null, returnErr = false) {
		try {
			let payload = { endpoint };

			if (data != null) payload["body"] = data;

			const res = await fetch(subDir, {
				method: "GET",
				body: JSON.stringify(payload),
			});

			return await res.json();
		} catch (e) {
			if (returnErr) {
				return {
					message: "An error occured.",
					error: e,
				};
			}
			return "An error occured.";
		}
	},
	async post(subDir, endpoint, data, returnErr = false) {
		try {
			let payload = { endpoint, data };
			const res = await fetch(subDir, {
				method: "POST",
				body: JSON.stringify(payload),
			});

			return await res.json();
		} catch (e) {
			if (returnErr) {
				return {
					message: "An error occured.",
					error: e,
				};
			}
			return "An error occured.";
		}
	},
};
