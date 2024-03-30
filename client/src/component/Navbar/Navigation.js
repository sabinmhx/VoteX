import React, { useState } from "react";
import { NavLink } from "react-router-dom";

import "./Navbar.css";

export default function Navbar() {
  const [open, setOpen] = useState(false);

  return (
    <nav className="navbar">
      <NavLink to="/" className="header">
        <i className="fab fa-hive"></i> Home
      </NavLink>
      <ul className={`navbar-links ${open ? 'active' : ''}`}>
        <li>
          <NavLink to="/Registration" activeClassName="nav-active" onClick={() => setOpen(false)}>
            <i className="far fa-registered" /> Registration
          </NavLink>
        </li>
        <li>
          <NavLink to="/Voting" activeClassName="nav-active" onClick={() => setOpen(false)}>
            <i className="fas fa-vote-yea" /> Voting
          </NavLink>
        </li>
        <li>
          <NavLink to="/Results" activeClassName="nav-active" onClick={() => setOpen(false)}>
            <i className="fas fa-poll-h" /> Results
          </NavLink>
        </li>
        <li>
          <NavLink to="/Guidelines" activeClassName="nav-active" onClick={() => setOpen(false)}>
            <i className="fas fa-info-circle" /> Voting Guidelines
          </NavLink>
        </li>
      </ul>
      <i onClick={() => setOpen(!open)} className={`fas fa-bars burger-menu ${open ? 'active' : ''}`}></i>
    </nav>
  );
}
