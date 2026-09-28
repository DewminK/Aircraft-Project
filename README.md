# Aircraft Project

A rule-based decision support system for Airbus A350-900 departure and
landing decisions, built with SWI-Prolog (backward/forward chaining +
explanation) and a React UI for interacting with it.

## Project structure

```
backend/    SWI-Prolog rule engine + HTTP API
frontend/   React (Vite) UI that calls the API
```

## Prerequisites

- [SWI-Prolog](https://www.swi-prolog.org/download/stable) (`swipl` available on PATH)
- [Node.js](https://nodejs.org/) v18+ (includes `npm`)

## 1. Start the backend

```
cd backend
swipl main.pl
```

This starts the HTTP API at `http://localhost:8000/api/evaluate` and keeps
running — leave this terminal open. CORS is already enabled so the frontend
(on a different port) can call it.

To run the Prolog test suite instead of the server:

```
cd backend
swipl -g "consult(test_cases), run_tests, halt"
```

## 2. Start the frontend

In a second terminal:

```
cd frontend
npm install
npm run dev
```

`npm install` only needs to be run once (or after `package.json` changes).
`npm run dev` starts the Vite dev server, by default at
`http://localhost:5173`.

## 3. Use the app

Open `http://localhost:5173` in a browser. Fill in the aircraft weight,
system status, runway/weather conditions, etc., choose **Departure** or
**Landing**, and submit — the UI sends the form to the Prolog backend and
displays the decision, derived facts, and explanation it returns.

The backend must be running on port 8000 for the frontend to work.
