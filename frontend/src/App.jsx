import { useState } from 'react'
import './App.css'

const API_URL = 'http://localhost:8000/api/evaluate'

const DEFAULT_FORM = {
  decisionType: 'departure',

  aircraftWeight: 250000,
  landingWeight: 195000,
  zeroFuelWeight: 180000,
  fuelQuantity: 120000,

  engineStatus: 'normal',
  flightControls: 'normal',
  landingGear: 'normal',
  hydraulicSystem: 'normal',
  electricalSystem: 'normal',

  takeoffRunwayAvailable: 'yes',
  takeoffRunwayCondition: 'dry',
  takeoffClearance: 'yes',
  takeoffConfiguration: 'configured',

  landingRunwayAvailable: 'yes',
  landingRunwayCondition: 'dry',
  approachSpeed: 140,
  crosswindSpeed: 10,
  goAroundAvailable: 'yes',

  weatherCondition: 'normal',
  visibilityCondition: 'good',
}

const NUMBER_FIELDS = new Set([
  'aircraftWeight',
  'landingWeight',
  'zeroFuelWeight',
  'fuelQuantity',
  'approachSpeed',
  'crosswindSpeed',
])

const STATUS_OPTIONS = ['normal', 'fault']
const YES_NO_OPTIONS = ['yes', 'no']

function Field({ label, name, value, onChange, options, type = 'select' }) {
  return (
    <label className="field">
      <span>{label}</span>
      {type === 'select' ? (
        <select name={name} value={value} onChange={onChange}>
          {options.map((opt) => (
            <option key={opt} value={opt}>
              {opt}
            </option>
          ))}
        </select>
      ) : (
        <input
          type="number"
          name={name}
          value={value}
          onChange={onChange}
        />
      )}
    </label>
  )
}

function App() {
  const [form, setForm] = useState(DEFAULT_FORM)
  const [result, setResult] = useState(null)
  const [error, setError] = useState(null)
  const [loading, setLoading] = useState(false)

  function handleChange(e) {
    const { name, value } = e.target
    setForm((prev) => ({
      ...prev,
      [name]: NUMBER_FIELDS.has(name) ? Number(value) : value,
    }))
  }

  function handleReset() {
    setForm(DEFAULT_FORM)
    setResult(null)
    setError(null)
  }

  async function handleSubmit(e) {
    e.preventDefault()
    setLoading(true)
    setError(null)
    setResult(null)

    try {
      const res = await fetch(API_URL, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(form),
      })

      if (!res.ok) {
        const text = await res.text()
        throw new Error(`Server responded ${res.status}: ${text}`)
      }

      const data = await res.json()
      setResult(data)
    } catch (err) {
      setError(
        err.message.includes('fetch')
          ? 'Could not reach the Prolog server. Is it running on http://localhost:8000?'
          : err.message
      )
    } finally {
      setLoading(false)
    }
  }

  const decisionClass = result
    ? result.decision === 'recommended'
      ? 'decision decision-good'
      : result.decision === 'go_around'
      ? 'decision decision-warn'
      : 'decision decision-bad'
    : ''

  return (
    <div className="page">
      <header>
        <h1>Aircraft Decision Checker</h1>
        <p className="subtitle">
          Airbus A350-900 departure / landing rule engine (SWI-Prolog backend)
        </p>
      </header>

      <form onSubmit={handleSubmit} className="panel">
        <div className="decision-type">
          <label>
            <input
              type="radio"
              name="decisionType"
              value="departure"
              checked={form.decisionType === 'departure'}
              onChange={handleChange}
            />
            Departure
          </label>
          <label>
            <input
              type="radio"
              name="decisionType"
              value="landing"
              checked={form.decisionType === 'landing'}
              onChange={handleChange}
            />
            Landing
          </label>
        </div>

        <fieldset>
          <legend>Weights &amp; Fuel</legend>
          <div className="grid">
            <Field type="number" label="Aircraft weight (kg)" name="aircraftWeight" value={form.aircraftWeight} onChange={handleChange} />
            <Field type="number" label="Landing weight (kg)" name="landingWeight" value={form.landingWeight} onChange={handleChange} />
            <Field type="number" label="Zero-fuel weight (kg)" name="zeroFuelWeight" value={form.zeroFuelWeight} onChange={handleChange} />
            <Field type="number" label="Fuel quantity (L)" name="fuelQuantity" value={form.fuelQuantity} onChange={handleChange} />
          </div>
        </fieldset>

        <fieldset>
          <legend>Aircraft Systems</legend>
          <div className="grid">
            <Field label="Engine status" name="engineStatus" value={form.engineStatus} onChange={handleChange} options={STATUS_OPTIONS} />
            <Field label="Flight controls" name="flightControls" value={form.flightControls} onChange={handleChange} options={STATUS_OPTIONS} />
            <Field label="Landing gear" name="landingGear" value={form.landingGear} onChange={handleChange} options={STATUS_OPTIONS} />
            <Field label="Hydraulic system" name="hydraulicSystem" value={form.hydraulicSystem} onChange={handleChange} options={STATUS_OPTIONS} />
            <Field label="Electrical system" name="electricalSystem" value={form.electricalSystem} onChange={handleChange} options={STATUS_OPTIONS} />
          </div>
        </fieldset>

        {form.decisionType === 'departure' && (
          <fieldset>
            <legend>Takeoff</legend>
            <div className="grid">
              <Field label="Runway available" name="takeoffRunwayAvailable" value={form.takeoffRunwayAvailable} onChange={handleChange} options={YES_NO_OPTIONS} />
              <Field label="Runway condition" name="takeoffRunwayCondition" value={form.takeoffRunwayCondition} onChange={handleChange} options={['dry', 'poor']} />
              <Field label="Takeoff clearance" name="takeoffClearance" value={form.takeoffClearance} onChange={handleChange} options={YES_NO_OPTIONS} />
              <Field label="Configuration" name="takeoffConfiguration" value={form.takeoffConfiguration} onChange={handleChange} options={['configured', 'not_configured']} />
            </div>
          </fieldset>
        )}

        {form.decisionType === 'landing' && (
          <fieldset>
            <legend>Landing</legend>
            <div className="grid">
              <Field label="Runway available" name="landingRunwayAvailable" value={form.landingRunwayAvailable} onChange={handleChange} options={YES_NO_OPTIONS} />
              <Field label="Runway condition" name="landingRunwayCondition" value={form.landingRunwayCondition} onChange={handleChange} options={['dry', 'poor']} />
              <Field type="number" label="Approach speed (kt)" name="approachSpeed" value={form.approachSpeed} onChange={handleChange} />
              <Field type="number" label="Crosswind speed (kt)" name="crosswindSpeed" value={form.crosswindSpeed} onChange={handleChange} />
              <Field label="Go-around available" name="goAroundAvailable" value={form.goAroundAvailable} onChange={handleChange} options={YES_NO_OPTIONS} />
            </div>
          </fieldset>
        )}

        <fieldset>
          <legend>Environment</legend>
          <div className="grid">
            <Field label="Weather condition" name="weatherCondition" value={form.weatherCondition} onChange={handleChange} options={['normal', 'adverse']} />
            <Field label="Visibility condition" name="visibilityCondition" value={form.visibilityCondition} onChange={handleChange} options={['good', 'poor']} />
          </div>
        </fieldset>

        <div className="actions">
          <button type="submit" disabled={loading}>
            {loading ? 'Evaluating…' : 'Evaluate'}
          </button>
          <button type="button" className="secondary" onClick={handleReset}>
            Reset
          </button>
        </div>
      </form>

      {error && <div className="panel error">{error}</div>}

      {result && (
        <div className="panel result">
          <h2>Result</h2>
          <p className={decisionClass}>{result.decision}</p>
          <p className="aircraft">{result.aircraft}</p>

          <h3>Derived facts</h3>
          {result.derivedFacts?.length ? (
            <ul>
              {result.derivedFacts.map((f) => (
                <li key={f}>{f}</li>
              ))}
            </ul>
          ) : (
            <p className="muted">None</p>
          )}

          <h3>Explanation</h3>
          <ul>
            {result.explanation.map((line, i) => (
              <li key={i}>{line}</li>
            ))}
          </ul>
        </div>
      )}
    </div>
  )
}

export default App
