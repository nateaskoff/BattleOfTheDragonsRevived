import { render, screen } from '@testing-library/react';
import App from './App';

test('renders the coming soon message', () => {
  render(<App />);
  
  // Change the test to look for your new content
  const comingSoonElement = screen.getByText(/Website Coming Soon/i);
  expect(comingSoonElement).toBeInTheDocument();
});

test('renders the Discord link', () => {
  render(<App />);

  const discordLink = screen.getByText(/Join our Discord/i);
  expect(discordLink).toBeInTheDocument();
});

test('renders the GitHub link', () => {
  render(<App />);

  const githubLink = screen.getByText(/View our GitHub/i);
  expect(githubLink).toBeInTheDocument();
});
