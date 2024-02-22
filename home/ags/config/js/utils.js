import Gdk from 'gi://Gdk';
const { exec } = Utils;

export function forMonitors(widget) {
    const n = Gdk.Display.get_default()?.get_n_monitors() || 1;
    return range(n, 0).map(widget).flat(1);}

export function range(length, start = 1) { return Array.from({ length }, (_, i) => i + start);}

export const distroID = exec(`bash -c 'cat /etc/os-release | grep "^ID=" | cut -d "=" -f 2'`).trim();
