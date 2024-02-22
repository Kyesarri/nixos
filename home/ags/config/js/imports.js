const resource = file => `resource:///com/github/Aylur/ags/${file}.js`;
const require = async file => (await import(resource(file))).default;
const service = async file => (await require(`service/${file}`));

export const Widget = await require('widget');
export const Variable = await require('variable');
export const Utils = await import(resource('utils'));

export const Battery = await service('battery');
export const Hyprland = await service('hyprland');
export const SystemTray = await service('systemtray');
export const Audio = await service('audio'); 

//21.02.24
//export const App = await require('app');
//export const Service = await require('service');
// export const Applications = await service('applications');
//export const Bluetooth = await service('bluetooth');
///*export const Mpris = await service('mpris'); */
//export const Network = await service('network');
///*export const Notifications = await service('notifications');*/
