// SPDX-FileCopyrightText: 2023 XWiki CryptPad Team <contact@cryptpad.org> and contributors
//
// SPDX-License-Identifier: AGPL-3.0-or-later

module.exports = {

  httpUnsafeOrigin: 'https://cryptpad.galing.org',
  httpSafeOrigin: "https://cryptpad-sb.galing.org",
  httpAddress: 'localhost',
  httpPort: 3000,
  httpSafePort: 3001,
  websocketPort: 3003,
  maxWorkers: 4,

    /* =====================
     *       Sessions
     * ===================== */

    /*  Accounts can be protected with an OTP (One Time Password) system
     *  to add a second authentication layer. Such accounts use a session
     *  with a given lifetime after which they are logged out and need
     *  to be re-authenticated. You can configure the lifetime of these
     *  sessions here.
     *
     *  defaults to 7 days
     */
    //otpSessionExpiration: 7*24, // hours

    /*  Registered users can be forced to protect their account
     *  with a Multi-factor Authentication (MFA) tool like a TOTP
     *  authenticator application.
     *
     *  defaults to false
     */
    enforceMFA: false,

    /* =====================
     *       Privacy
     * ===================== */

    /*  Depending on where your instance is hosted, you may be required to log IP
     *  addresses of the users who make a change to a document. This setting allows you
     *  to do so. You can configure the logging system below in this config file.
     *  Setting this value to true will include a log for each websocket connection
     *  including this connection's unique ID, the user public key and the IP.
     *  NOTE: this option requires a log level of "info" or below.
     *
     *  defaults to false
     */
    logIP: true,

    /* =====================
     *         Admin
     * ===================== */

    /*
     *  CryptPad contains an administration panel. Its access is restricted to specific
     *  users using the following list.
     *  To give access to the admin panel to a user account, just add their public signing
     *  key, which can be found on the settings page for registered users.
     *  Entries should be strings separated by a comma.
     *  adminKeys: [
     *      "[cryptpad-user1@my.awesome.website/YZgXQxKR0Rcb6r6CmxHPdAGLVludrAF2lEnkbx1vVOo=]",
     *      "[cryptpad-user2@my.awesome.website/jA-9c5iNuG7SyxzGCjwJXVnk5NPfAOO8fQuQ0dC83RE=]",
     *  ]
     *
     */
    adminKeys: [

    ],
    inactiveTime: 1, // days
    disableIntegratedEviction: false,
    filePath: './datastore/',
    archivePath: './data/archive',
    pinPath: './data/pins',
    taskPath: './data/tasks',
    blockPath: './block',
    blobPath: './blob',
    blobStagingPath: './data/blobstage',
    decreePath: './data/decrees',
    logPath: './data/logs',

    logToStdout: false,
    logLevel: 'info',
    logFeedback: false,
    verbose: false,
    installMethod: 'podman',
};
