import Gdk from 'gi://Gdk';

/** @type {function(string): number[]}*/
export const hexToRgb = hex =>
    hex.replace(/^#?([a-f\d])([a-f\d])([a-f\d])$/i
        , (r, g, b) => '#' + r + r + g + g + b + b)
        .substring(1).match(/.{2}/g)
        .map(x => parseInt(x, 16));

/*export function reloadCss() {
    return Utils.subprocess([
        'inotifywait',
        '--recursive',
        '--event', 'create,modify',
        '-m', App.configDir + '/scss',
    ], () => {
        Utils.exec(`sassc ${App.configDir}/scss/main.scss ${App.configDir}/style.css`);
        App.resetCss();
        App.applyCss(`${App.configDir}/style.css`);
    });
}*/

/** @type {function(number, number): number[]}*/
export function range(length, start = 1) {
    return Array.from({ length }, (_, i) => i + start);
}

/** @type {function([any], any): any}*/
export function substitute(collection, item) {
    return collection.find(([from]) => from === item)?.[1] || item;
}

/** @type {function((id: number) => typeof Gtk.Widget): typeof Gtk.Widget[]}*/
//export function forMonitors(widget) {
//    const n = Gdk.Display.get_default().get_n_monitors();
//    return range(n, 0).map(widget);
//}

/**
  * @param {(monitor: number) => any} widget
  * @returns {Array<import('types/widgets/window').default>}
  */
export function forMonitors(widget) {
    const n = Gdk.Display.get_default()?.get_n_monitors() || 1;
    return range(n, 0).map(widget).flat(1);
}


//export async function globalServices() {
//    globalThis.ags = await import('./imports.js');
//}

//export function launchApp(app) {
//    Utils.execAsync(`hyprctl dispatch exec "${app.executable}"`);
//    app.frequency += 1;
//}
