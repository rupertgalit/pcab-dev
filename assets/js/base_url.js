const { pathname, origin } = window.location;
const path_arr = pathname.split("/");
path_arr.shift();

export default origin.concat(path_arr[0] != "declarator" ? `/${path_arr[0]}` : "");
